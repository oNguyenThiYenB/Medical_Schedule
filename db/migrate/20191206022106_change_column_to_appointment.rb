class ChangeColumnToAppointment < ActiveRecord::Migration[6.0]
  def change
    change_column :appointments, :status, :integer, default: 0
  end
end
