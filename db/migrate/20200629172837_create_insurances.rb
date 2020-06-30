class CreateInsurances < ActiveRecord::Migration[6.0]
  def change
    create_table :insurances do |t|
      t.references :patient
      t.string :card_number
      t.integer :gender
      t.date :date_of_birth
      t.date :start_date
      t.date :due_date

      t.timestamps
    end
  end
end
