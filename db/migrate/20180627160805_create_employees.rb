class CreateEmployees < ActiveRecord::Migration[5.2]
  def change
    create_table :employees do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.integer :allowed_services, limit: 2, array: true, default: '{}'
      t.timestamps null: false
    end
  end
end
