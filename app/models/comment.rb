class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :patient

  delegate :full_name, to: :patient, prefix: true

  validates :content, presence: true
  scope :order_by_created_at, ->{order created_at: :desc}
end
