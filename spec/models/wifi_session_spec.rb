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

require 'rails_helper'

RSpec.describe WifiSession, type: :model do
  describe '.create' do
    subject do
      described_class.create(create_params)
    end

    let(:create_params) { { session_id: '123' } }

    include_examples :creates_record
    include_examples :changes_records_count_of, described_class, by: 1

    context 'with optional attributes' do
      let(:create_params) do
        super().merge connect_info: 'connect_info',
                      bytes_rx: '123',
                      bytes_tx: '456',
                      duration: '789',
                      nas_identifier: 'nas_identifier',
                      nas_ip_address: '127.0.0.1',
                      nas_port_type: 'nas_port_type',
                      packets_rx: '1234',
                      packets_tx: '5678',
                      terminate_cause: 'terminate_cause',
                      username: 'username',
                      called_station_id: 'called_station_id',
                      calling_station_id: 'calling_station_id'
      end

      include_examples :creates_record
      include_examples :changes_records_count_of, described_class, by: 1
    end
  end
end
