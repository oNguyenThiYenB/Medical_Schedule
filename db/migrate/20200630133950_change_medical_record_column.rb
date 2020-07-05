class ChangeMedicalRecordColumn < ActiveRecord::Migration[6.0]
  def change
    remove_reference :medical_records, :patient
    add_reference :medical_records, :appointment
    add_column :medical_records, :health_condition, :string, null: false
    add_column :medical_records, :diagnoses, :string, null: false
  end
end
