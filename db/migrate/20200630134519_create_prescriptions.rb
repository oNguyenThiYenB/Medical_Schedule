class CreatePrescriptions < ActiveRecord::Migration[6.0]
  def change
    create_table :prescriptions do |t|
      t.references :appointment
      t.integer :quantity
      t.string :dosage

      t.timestamps
    end
  end
end
