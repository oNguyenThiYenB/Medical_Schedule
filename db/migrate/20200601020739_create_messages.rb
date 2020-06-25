class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.text :body
      t.integer :sender_id, null: false
      t.integer :receiver_id, null: false
      t.references :conversation, null: false, foreign_key: true

      t.timestamps
    end
  end
end
