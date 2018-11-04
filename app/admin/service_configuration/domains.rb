ActiveAdmin.register Domain do
  menu parent: 'Services configuration', priority: 20

  # actions :index
  config.batch_actions = false

  permit_params :fqdn

  filter :id
  filter :fqdn

  index do
    id_column
    actions
    column :fqdn
    column :created_at
    column :updated_at
  end

  show do
    attributes_table do
      row :id
      row :fqdn
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)
    f.inputs do
      f.input :fqdn
    end
    f.actions
  end
end
