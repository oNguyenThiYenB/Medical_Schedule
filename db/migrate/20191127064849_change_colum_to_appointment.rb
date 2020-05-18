class ChangeColumToAppointment < ActiveRecord::Migration[6.0]
  def change
    change_column :appointments, :from_time, :time
    change_column :appointments, :to_time, :time
  end
end
