class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :patient

  delegate :full_name, to: :patient, prefix: true

  validates :content, presence: true
end
