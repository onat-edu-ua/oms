ActiveAdmin.register WifiSession do
  actions :index, :show
  decorate_with WifiSessionDecorator
  config.current_filters = false
  config.batch_actions = false

  filter :session_id_eq, label: 'Session ID'
  filter :connect_info
  filter :duration
  filter :username
  filter :terminate_cause
  filter :called_station_id_eq, label: 'Called Station ID'
  filter :calling_station_id_eq, label: 'Calling Station ID'
  filter :nas_ip_address_eq, label: 'NAS IP Address'
  filter :nas_identifier
  filter :bytes_rx
  filter :bytes_tx
  filter :packets_rx
  filter :packets_tx
  filter :created_at
  filter :updated_at

  includes login_record: :login_entity

  index do
    id_column
    column :created_at
    column :updated_at
    column 'Session ID', :session_id, sortable: :session_id
    column :username, :login_link, sortable: :username
    column :connect_info
    column :terminate_cause
    column :nas_identifier
    column :nas_ip_address
    column :nas_port_type
    column :duration
    column :bytes_rx
    column :bytes_tx
    column :packets_rx
    column :packets_tx
    column 'Called Station ID', :called_station_id, sortable: :called_station_id
    column 'Calling Station ID', :calling_station_id, sortable: :calling_station_id
  end

  show do
    attributes_table do
      row :id
      row :created_at
      row :updated_at
      row 'Session ID' do
        resource.session_id
      end
      row :username do
        resource.login_link
      end
      row :connect_info
      row :terminate_cause
      row :nas_identifier
      row :nas_ip_address
      row :nas_port_type
      row :duration
      row :bytes_rx
      row :bytes_tx
      row :packets_rx
      row :packets_tx
      row 'Called Station ID' do
        resource.called_station_id
      end
      row 'Calling Station ID' do
        resource.calling_station_id
      end
    end
  end
end
