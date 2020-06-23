class Article < ApplicationRecord
  ARTICLE_PARAMS = %i(user_id article_category_id title content).freeze

  include Image

  has_many :comments, as: :commentable, dependent: :destroy
  belongs_to :user

  has_one_attached :thumbnail

  scope :by_created_at_desc, ->{order created_at: :desc}

  def display_thumbnail
    image.variant resize_to_limit: Settings.resize_to_limit_thumbnail
  end
end
