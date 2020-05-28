class Article < ApplicationRecord
  has_many :comments, as: :commentable, dependent: :destroy
  belongs_to :user

  has_many_attached :images
end
