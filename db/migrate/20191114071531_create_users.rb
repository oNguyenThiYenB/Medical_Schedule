class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :user_name
      t.string :full_name
      t.string :email
      t.string :address
      t.string :phone
      t.string :role
      t.string :department
      t.string :position
      t.integer :experience
      t.integer :room

      t.timestamps
    end
  end
end
