class CreateDoctorFaculties < ActiveRecord::Migration[6.0]
  def change
    create_table :doctor_faculties do |t|
      t.references :doctor, null: false
      t.references :faculty, null: false

      t.timestamps
    end
  end
end
