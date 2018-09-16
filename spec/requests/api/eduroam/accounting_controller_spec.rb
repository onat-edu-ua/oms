RSpec.describe Api::Eduroam::AccountingController do
  describe 'POST /api/eduroam/accounting/:session_id' do
    subject do
      post "/api/eduroam/accounting/#{session_id}", params: post_payload.to_json, headers: json_headers
    end

    shared_examples :success_session_write do
      # let(:record) {} # required
      it 'responds with 200 and correct payload' do
        subject
        expect(response.status).to eq(200)
        expect(response_json).to match('Acct-Session-Id': record.session_id)
      end

      it 'creates record with correct attributes' do
        subject
        expect(record).to have_attributes(expected_record_attributes)
      end
    end

    shared_examples :failed_session_write do |status: 422, error:|
      it "responds with #{status} and error payload" do
        subject
        expect(response.status).to eq(status)
        expect(response_json).to match(Error: error)
      end
    end

    let(:json_headers) { { 'Content-Type' => 'application/json' } }
    let(:session_id) { '00ABC753-00000001' }
    let(:post_payload) do
      {
          'Acct-Session-Id': session_id,
          'Acct-Status-Type': 'Stop',
          'Acct-Authentic': 'RADIUS',
          'User-Name': '1@onat.edu.ua',
          'NAS-IP-Address': '10.100.6.55',
          'NAS-Identifier': '0027220a14e7',
          'NAS-Port': '0',
          'Called-Station-Id': '0E-27-22-0B-14-E7:eduroam',
          'Calling-Station-Id': 'F4-31-C3-55-4B-D1',
          'NAS-Port-Type': 'Wireless-802.11',
          'Connect-Info': 'CONNECT 0Mbps 802.11b',
          'Acct-Session-Time': '512',
          'Acct-Input-Packets': '903',
          'Acct-Output-Packets': '753',
          'Acct-Input-Octets': '166060',
          'Acct-Output-Octets': '528779',
          'Event-Timestamp': 'May 11 1970 08:38:42 UTC',
          'Acct-Terminate-Cause': 'User-Request'
      }
    end
    let(:expected_record_attributes) do
      {
          session_id: post_payload[:'Acct-Session-Id'],
          connect_info: post_payload[:'Connect-Info'],
          bytes_rx: post_payload[:'Acct-Input-Octets'].to_i,
          bytes_tx: post_payload[:'Acct-Output-Octets'].to_i,
          duration: post_payload[:'Acct-Session-Time'].to_i,
          nas_identifier: post_payload[:'NAS-Identifier'],
          nas_ip_address: post_payload[:'NAS-IP-Address'],
          nas_port_type: post_payload[:'NAS-Port-Type'],
          packets_rx: post_payload[:'Acct-Input-Packets'].to_i,
          packets_tx: post_payload[:'Acct-Output-Packets'].to_i,
          terminate_cause: post_payload[:'Acct-Terminate-Cause'],
          username: post_payload[:'User-Name'],
          called_station_id: post_payload[:'Called-Station-Id'],
          calling_station_id: post_payload[:'Calling-Station-Id']
      }
    end

    before { FactoryBot.create(:wifi_session) }

    include_examples :changes_records_count_of, WifiSession, by: 1
    include_examples :success_session_write do
      let(:record) { WifiSession.last! }
    end

    context 'when wifi_session already exist' do
      let!(:wifi_session) { FactoryBot.create(:wifi_session, session_id: session_id) }

      it 'changes updated_at' do
        expect { subject }.to change { wifi_session.reload.updated_at }
      end

      include_examples :changes_records_count_of, WifiSession, by: 0
      include_examples :success_session_write do
        let(:record) { wifi_session.reload }
      end
    end

    context 'when session_id is an empty string' do
      let(:post_payload) { super().merge 'Acct-Session-Id': '' }

      include_examples :failed_session_write, error: "Acct session can't be blank"
      include_examples :changes_records_count_of, WifiSession, by: 0
    end

    context 'when session_id is an nil' do
      let(:post_payload) { super().merge 'Acct-Session-Id': nil }

      include_examples :failed_session_write, error: "Acct session can't be blank"
      include_examples :changes_records_count_of, WifiSession, by: 0
    end

    context 'when unexpected error appeared' do
      before do
        expect_any_instance_of(WifiSession).to receive(:save!).once.and_raise(StandardError, 'test error')
      end

      include_examples :failed_session_write, status: 500, error: 'server_error'
      include_examples :changes_records_count_of, WifiSession, by: 0
    end
  end
end
