class AddShiftWorkFromAppointments < ActiveRecord::Migration[6.0]
  def change
    add_reference :appointments, :shift_work, index: true, foreign_key: true
  end
end
