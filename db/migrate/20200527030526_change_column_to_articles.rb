class ChangeColumnToArticles < ActiveRecord::Migration[6.0]
  def change
    change_column :articles, :content, :text
    add_column :articles, :title, :string
    add_column :articles, :type, :string
    add_column :articles, :status, :string
    remove_reference :articles, :staff
    add_reference :articles, :article_category, index: true, foreign_key: true
    add_reference :articles, :user, index: true, foreign_key: true
  end
end
