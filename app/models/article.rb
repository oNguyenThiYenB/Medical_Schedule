class Article < ApplicationRecord
  ARTICLE_PARAMS = %i(user_id article_category_id title content).freeze

  has_many :comments, as: :commentable, dependent: :destroy
  belongs_to :user

  has_many_attached :images
end
