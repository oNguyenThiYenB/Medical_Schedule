class RemoveDoctorFromShiftWorks < ActiveRecord::Migration[6.0]
  def change
    remove_reference :shift_works, :doctor, null: false
  end
end
