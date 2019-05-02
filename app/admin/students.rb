ActiveAdmin.register Student do
  decorate_with StudentDecorator
  config.current_filters = false

  filter :first_name
  filter :last_name

  filter_select :login_record_allowed_services_arr_contains,
                label: 'Allowed Services',
                input_html: { multiple: true },
                collection: -> { Service.ordered }

  filter_select :login_record_allowed_services_empty,
                label: 'Allowed Services Empty',
                boolean: true,
                input_html: {
                    class: 'chosen-with-opts',
                    'data-chosen-opts': { disable_search: true }.to_json
                }

  filter :login_record_login, label: 'Login'
  filter :created_at
  filter :updated_at

  extended_batch_destroy!

  includes(:login_record)

  index do
    selectable_column
    id_column
    actions
    column :first_name
    column :last_name
    column :allowed_services, :service_tags
    column :login
    column :created_at
    column :updated_at
  end

  show do
    columns do
      column do
        attributes_table do
          row :id
          row :first_name
          row :last_name
          row :created_at
          row :updated_at
        end
      end

      column do
        panel 'Login Record' do
          attributes_table_for resource.login_record do
            row :id
            row :allowed_services do
              resource.service_tags
            end
            row :login
            row :password
            row :created_at
            row :updated_at
          end
        end
      end
    end
  end

  permit_params :first_name, :last_name,
                login_record_attributes: [:id, :login, :password, allowed_services: []]

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    f.inputs do
      f.input :first_name
      f.input :last_name
    end

    f.inputs for: [:login_record, f.object.login_record || LoginRecord.new] do |c|
      c.input :login
      c.input :password,
              as: :string,
              input_html: {
                  class: 'js-fill-password',
                  'data-password-length': 12
              }
      c.input :allowed_services,
              as: :select,
              collection: Service.ordered,
              input_html: {
                  multiple: true,
                  class: 'chosen-with-opts',
                  'data-chosen-opts': { width: '80%' }.to_json
              }
    end

    f.actions { f.submit }
  end
end
