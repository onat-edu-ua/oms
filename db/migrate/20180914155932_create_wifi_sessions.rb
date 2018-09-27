class CreateWifiSessions < ActiveRecord::Migration[5.2]
  def up
    # execute <<-SQL
    #   create table wifi_sessions(
    #     id bigserial primary key,
    #     session_id varchar not null unique,
    #     username varchar,
    #     nas_ip_address varchar,
    #     nas_identifier varchar,
    #     called_station_id varchar,
    #     calling_station_id varchar,
    #     nas_port_type varchar,
    #     connect_info varchar,
    #     duration integer not null default 0,
    #     packets_rx bigint not null default 0,
    #     packets_tx bigint not null default 0,
    #     bytes_rx bigint not null default 0,
    #     bytes_tx bigint not null default 0,
    #     updated_at timestamptz not null default now(),
    #     created_at timestamptz not null default now(),
    #     terminate_cause varchar
    #   );
    # SQL
    create_table :wifi_sessions, id: :primary_key do |t|
      t.string :session_id, null: false
      t.string :username
      t.string :nas_ip_address
      t.string :nas_identifier
      t.string :called_station_id
      t.string :calling_station_id
      t.string :nas_port_type
      t.string :connect_info
      t.integer :duration, null: false, default: 0
      t.integer :packets_rx, null: false, default: 0, limit: 8
      t.integer :packets_tx, null: false, default: 0, limit: 8
      t.integer :bytes_rx, null: false, default: 0, limit: 8
      t.integer :bytes_tx, null: false, default: 0, limit: 8
      t.column :updated_at, :timestamptz, null: false, default: -> { 'now()' }
      t.column :created_at, :timestamptz, null: false, default: -> { 'now()' }
      t.string :terminate_cause
    end
    add_index :wifi_sessions, :session_id, unique: true
  end

  def down
    drop_table :wifi_sessions
  end
end
