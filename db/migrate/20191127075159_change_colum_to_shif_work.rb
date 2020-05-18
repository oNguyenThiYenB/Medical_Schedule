class ChangeColumToShifWork < ActiveRecord::Migration[6.0]
  def change
    change_column :shift_works, :from_time, :time
    change_column :shift_works, :to_time, :time
  end
end
