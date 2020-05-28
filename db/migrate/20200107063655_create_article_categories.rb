class CreateArticleCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :article_categories do |t|
      t.string :article_category_name
      t.text :description

      t.timestamps
    end
  end
end
