class ChangeColumnToUsers < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :role, :string, default: "Patient"
  end
end
