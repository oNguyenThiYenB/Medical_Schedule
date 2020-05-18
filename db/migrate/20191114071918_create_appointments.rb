class CreateAppointments < ActiveRecord::Migration[6.0]
  def change
    create_table :appointments do |t|
      t.references :patient
      t.references :doctor
      t.integer :status
      t.datetime :from_time
      t.datetime :to_time
      t.string :phone_patient
      t.string :address_patient
      t.text :message

      t.timestamps
    end
  end
end
