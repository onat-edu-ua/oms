ActiveAdmin.register Email::Redirect do
  menu parent: 'Services configuration', priority: 30
  # actions :index
  config.batch_actions = false

  includes :domain
  permit_params :username, :domain_id, :rewrited_destination

  filter :id
  filter :username
  filter :domain

  index do
    id_column
    actions
    column :username
    column :domain
    column :rewrited_destination
    column :created_at
    column :updated_at
  end

  show do
    attributes_table do
      row :id
      row :username
      row :domain
      row :rewrited_destination
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)
    f.inputs do
      f.input :username
      f.input :domain
      f.input :rewrited_destination
    end
    f.actions
  end
end
