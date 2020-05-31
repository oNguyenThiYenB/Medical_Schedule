module ArticlesHelper
  def article_categories
    ArticleCategory.pluck :article_category_name, :id
  end
end
