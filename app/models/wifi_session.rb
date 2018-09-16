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

class WifiSession < ApplicationRecord
  belongs_to :login_record, foreign_key: :username, primary_key: :login, required: false, inverse_of: :wifi_sessions

  validates :session_id, presence: true
  validates :bytes_rx, :bytes_tx, :duration, :packets_rx, :packets_tx,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
