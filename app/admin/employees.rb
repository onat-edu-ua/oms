ActiveAdmin.register Employee do
  decorate_with EmployeeDecorator
  config.current_filters = false

  filter :last_name
  filter :first_name
  filter :middle_name

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

  filter :inn
  filter :passport_number
  filter :phone_number
  filter :email
  filter :login_record_login, label: 'Login'
  filter :created_at
  filter :updated_at

  extended_batch_destroy!

  controller do
    def scoped_collection
      super.preload(:login_record)
    end
  end

  index do
    selectable_column
    id_column
    actions
    column :last_name
    column :first_name
    column :middle_name
    column :allowed_services, :service_tags
    column :login
    column :inn
    column :passport_number
    column :phone_number
    column :email
    column :created_at
    column :updated_at
  end

  show do
    columns do
      column do
        attributes_table do
          row :id
          row :last_name
          row :first_name
          row :middle_name
          row :inn
          row :passport_number
          row :phone_number
          row :email
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
                :inn, :passport_number, :middle_name, :phone_number, :email,
                login_record_attributes: [:id, :login, :password, allowed_services: []]

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    f.inputs do
      f.input :last_name
      f.input :first_name
      f.input :middle_name
      f.input :inn
      f.input :passport_number
      f.input :phone_number
      f.input :email
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
