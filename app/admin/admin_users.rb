ActiveAdmin.register AdminUser do
  permit_params do
    attrs = [:email, :password, :password_confirmation]
    # not root admin_user can't edit root admin_users
    !current_admin_user.root? && resource.root? ? [] : attrs
  end

  index do
    selectable_column
    id_column
    column :email
    column :role
    column :created_at
    column :updated_at
    actions
  end

  show do
    columns do
      column do
        attributes_table do
          row :id
          row :email
          row :role
          row :created_at
          row :updated_at
        end
      end

      column do
        active_admin_comments
      end
    end
  end

  action_item :set_role, only: :show, if: proc { authorized?(:set_role, resource) } do
    modal_link 'Set Role',
               inputs: { role: AdminUser.allowed_roles },
               default_values: { role: resource.role }
  end

  member_action :set_role, method: :put do
    wrap_action do
      role = params.require(:set_role).require(:role)
      form = SetRoleForm.new(role: role, model: resource, initiator: current_admin_user)
      form.save!
      flash[:notice] = 'Role was changed successfully!'
    end
  end

  filter :id
  filter :email
  filter_select :role, as: :select, collection: AdminUser.allowed_roles
  filter :created_at
  filter :updated_at

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end
end
