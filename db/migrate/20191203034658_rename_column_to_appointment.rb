class RenameColumnToAppointment < ActiveRecord::Migration[6.0]
  def change
    rename_column :appointments, :from_time, :start_time
    rename_column :appointments, :to_time, :end_time
  end
end
