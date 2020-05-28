class CreateArticles < ActiveRecord::Migration[6.0]
  def change
    create_table :articles do |t|
      t.references :staff
      t.string :content

      t.timestamps
    end
  end
end
