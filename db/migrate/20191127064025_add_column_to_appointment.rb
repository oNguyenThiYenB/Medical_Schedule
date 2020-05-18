class AddColumnToAppointment < ActiveRecord::Migration[6.0]
  def change
    add_column :appointments, :day, :date
  end
end
