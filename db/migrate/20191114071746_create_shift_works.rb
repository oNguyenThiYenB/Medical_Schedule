class CreateShiftWorks < ActiveRecord::Migration[6.0]
  def change
    create_table :shift_works do |t|
      t.references :doctor
      t.datetime :from_time
      t.datetime :to_time

      t.timestamps
    end
  end
end
