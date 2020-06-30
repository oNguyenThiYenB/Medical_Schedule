class Patient < User
  PATIENT_PARAMS = %i(user_name full_name email phone address
    password password_confirmation).freeze

  has_many :comments, dependent: :destroy
  has_many :appointments, dependent: :destroy
  has_many :rates, dependent: :destroy
  has_many :conversations, foreign_key: :patient_id
  has_many :insurances, foreign_key: :patient_id

  delegate :card_number, :date_of_birth, :gender, :start_date, :due_date, to: :insurances, prefix: true
end
