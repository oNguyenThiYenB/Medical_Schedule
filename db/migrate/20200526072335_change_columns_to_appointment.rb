class ChangeColumnsToAppointment < ActiveRecord::Migration[6.0]
  def change
    remove_column :appointments, :start_time, :time
    remove_column :appointments, :end_time, :time
    add_column :appointments, :number, :integer
    add_column :appointments, :insurance, :boolean, default: false
  end
end
