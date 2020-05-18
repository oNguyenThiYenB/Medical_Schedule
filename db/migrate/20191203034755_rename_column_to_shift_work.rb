class RenameColumnToShiftWork < ActiveRecord::Migration[6.0]
  def change
    rename_column :shift_works, :from_time, :start_time
    rename_column :shift_works, :to_time, :end_time
  end
end
