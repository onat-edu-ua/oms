class AddRoleToAdminUser < ActiveRecord::Migration[5.2]
  def up
    add_column :admin_users, :role, :string, default: 'user', null: false
    change_column_default :admin_users, :role, nil
  end

  def down
    remove_column :admin_users, :role
  end
end
