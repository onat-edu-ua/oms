ActiveAdmin.register Student do
  decorate_with StudentDecorator
  config.current_filters = false

  filter :first_name
  filter :last_name

  filter :login_record_allowed_services_arr_contains,
         as: :select, label: 'Allowed Services',
         input_html: { multiple: true, class: :chosen },
         collection: -> { Service.ordered }

  filter :login_record_allowed_services_empty,
         as: :select, label: 'Allowed Services Empty',
         collection: [['Yes', true], ['No', false]],
         input_html: {
             class: 'chosen-with-opts',
             'data-chosen-opts': { disable_search: true }.to_json
         }

  filter :login_record_login, label: 'Login'
  filter :created_at
  filter :updated_at

  batch_action :destroy, confirm: 'Are you sure that you want to destroy those record?' do |ids|
    errors = []
    success_qty = 0
    scope = apply_authorization_scope(scoped_collection).where(id: ids)
    scope.find_each do |record|
      begin
        record.destroy
        if record.destroyed?
          success_qty += 1
        else
          error = record.errors.any? ? record.errors.full_messages.to_sentence : 'Failed to destroy record'
          errors.push("##{record.id} - #{error}")
        end
      rescue StandardError => e
        errors.push("##{record.id} - <#{e.class}>: #{e.message}")
        Rails.logger.error { "<#{e.class}>: #{e.message}\n#{e.backtrace.join("\n")}" }
      end
    end
    if success_qty.positive? || ids.size.zero?
      flash[:notice] = "#{success_qty}/#{ids.size} record were successfully destroyed."
    end
    flash[:error] = errors.join("\n") unless errors.empty?
    redirect_back(fallback_location: admin_root_path)
  end

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
