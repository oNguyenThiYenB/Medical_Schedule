class AddCancelReasonColumnToAppointment < ActiveRecord::Migration[6.0]
  def change
    add_column :appointments, :cancel_reason, :string
  end
end
