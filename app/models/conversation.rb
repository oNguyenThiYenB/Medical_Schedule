class Conversation < ApplicationRecord
  has_many :messages, dependent: :destroy
  belongs_to :patient, foreign_key: :patient_id
  belongs_to :host, -> { where(role: [:staff, :nurse]) }, foreign_key: :host_id, class_name: User.name

  # validates :sender_id, uniqueness: { scope: :recipient_id }

  def opposed_user(user)
    user == patient ? host : patient
  end

  scope :between, -> (host_id, patient_id) do
    where(host_id: host_id, patient_id: patient_id).or(
      where(host_id: patient_id, patient_id: host_id)
    )
  end

  def self.get(host_id, patient_id)
    conversation = between(host_id, patient_id).first
    return conversation if conversation.present?

    create(host_id: host_id, patient_id: patient_id)
  end
end
