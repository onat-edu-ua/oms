module ParamsParser
  class WifiSessionParser < Base
    def initialize(params)
      attrs = params.to_unsafe_h.transform_keys { |key| key.to_s.underscore }
      super ActionController::Parameters.new(attrs)
    end

    # POST /api/eduroam/accounting/00ABC753-00000001
    # with json
    # Acct-Session-Id = "00ABC753-00000001"
    # Acct-Status-Type = Stop
    # Acct-Authentic = RADIUS
    # User-Name = "1@onat.edu.ua"
    # NAS-IP-Address = 10.100.6.55
    # NAS-Identifier = "0027220a14e7"
    # NAS-Port = 0
    # Called-Station-Id = "0E-27-22-0B-14-E7:eduroam"
    # Calling-Station-Id = "F4-31-C3-55-4B-D1"
    # NAS-Port-Type = Wireless-802.11
    # Connect-Info = "CONNECT 0Mbps 802.11b"
    # Acct-Session-Time = 512
    # Acct-Input-Packets = 903
    # Acct-Output-Packets = 753
    # Acct-Input-Octets = 166060
    # Acct-Output-Octets = 528779
    # Event-Timestamp = "May 11 1970 08:38:42 UTC"
    # Acct-Terminate-Cause = User-Request
    def permitted_params
      [
          :acct_session_id,
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
      ]
    end
  end
end
