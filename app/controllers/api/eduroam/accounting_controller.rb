module Api
  module Eduroam
    class AccountingController < ApiController
      def create
        record = WifiSessionForm.new(permitted_params)
        if record.save
          render status: :ok, json: { 'Acct-Session-Id': record.acct_session_id }
        else
          render status: :unprocessable_entity, json: { Error: record.errors.full_messages.to_sentence }
        end
      end

      def permitted_params
        # params[:session_id] ignored
        ParamsParser::WifiSessionParser.new(params).permit!
      end

      def server_error(err)
        log_error(err)
        render status: :internal_server_error, json: { Error: :server_error }
      end
    end
  end
end
