class CreateConversations < ActiveRecord::Migration[6.0]
  def change
    create_table :conversations do |t|
      t.integer :patient_id
      t.integer :host_id

      t.timestamps
    end
    
    add_index :conversations, [:patient_id, :host_id], unique: true
  end
end
