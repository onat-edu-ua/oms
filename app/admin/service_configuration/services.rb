ActiveAdmin.register Service do
  menu parent: 'Services configuration', priority: 10

  actions :index
  config.batch_actions = false
  config.filters = false

  index do
    column :id
    column :name
    column :created_at
    column :updated_at
  end
end
