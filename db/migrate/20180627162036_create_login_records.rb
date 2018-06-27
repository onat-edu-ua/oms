class CreateLoginRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :login_records do |t|
      t.integer :login_entity_id, null: false
      t.string :login_entity_type, null: false
      t.string :login, null: false
      t.string :password_digest, null: false
      t.timestamps null: false
    end

    add_index :login_records, [:login_entity_id, :login_entity_type], unique: true
    add_index :login_records, :login, unique: true
  end
end
