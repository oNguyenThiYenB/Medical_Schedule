class AddColumnToShiftWork < ActiveRecord::Migration[6.0]
  def change
    add_column :shift_works, :day, :date
  end
end
