class CreateMedicinePrescriptions < ActiveRecord::Migration[6.0]
  def change
    create_table :medicine_prescriptions do |t|
      t.references :medicine
      t.references :prescription


      t.timestamps
    end
  end
end
