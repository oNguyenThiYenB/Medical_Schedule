class CreateRates < ActiveRecord::Migration[6.0]
  def change
    create_table :rates do |t|
      t.references :patient
      t.references :doctor
      t.integer :point

      t.timestamps
    end
  end
end
