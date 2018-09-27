# == Schema Information
#
# Table name: wifi_sessions
#
#  id                 :bigint(8)        not null, primary key
#  bytes_rx           :bigint(8)        default(0), not null
#  bytes_tx           :bigint(8)        default(0), not null
#  connect_info       :string
#  duration           :integer          default(0), not null
#  nas_identifier     :string
#  nas_ip_address     :string
#  nas_port_type      :string
#  packets_rx         :bigint(8)        default(0), not null
#  packets_tx         :bigint(8)        default(0), not null
#  terminate_cause    :string
#  username           :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  called_station_id  :string
#  calling_station_id :string
#  session_id         :string           not null
#
# Indexes
#
#  index_wifi_sessions_on_session_id  (session_id) UNIQUE
#

class WifiSessionForm < ApplicationForm
  attributes :acct_session_id,
             # :acct_status_type,
             # :acct_authentic,
             :user_name,
             :nas_ip_address,
             :nas_identifier,
             # :nas_port,
             :called_station_id,
             :calling_station_id,
             :nas_port_type,
             :connect_info,
             :acct_session_time,
             :acct_input_packets,
             :acct_output_packets,
             :acct_input_octets,
             :acct_output_octets,
             # :event_timestamp,
             :acct_terminate_cause

  validates :acct_session_id, presence: true

  def _save
    record = WifiSession.find_or_initialize_by(session_id: acct_session_id)
    record.assign_attributes(record_attributes)
    record.save!
  end

  def record_attributes
    # Ignored attributes:
    #   acct_status_type acct_authentic event_timestamp nas_port
    {
        connect_info: connect_info,
        bytes_rx: acct_input_octets,
        bytes_tx: acct_output_octets,
        duration: acct_session_time,
        nas_identifier: nas_identifier,
        nas_ip_address: nas_ip_address,
        nas_port_type: nas_port_type,
        packets_rx: acct_input_packets,
        packets_tx: acct_output_packets,
        terminate_cause: acct_terminate_cause,
        username: user_name,
        called_station_id: called_station_id,
        calling_station_id: calling_station_id
    }.reject { |_, v| v.blank? }
  end
end
