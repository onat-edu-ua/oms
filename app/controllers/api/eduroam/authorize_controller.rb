module Api
  module Eduroam
    class AuthorizeController < ApiController
      rescue_from EduroamAuthorize::NotFoundError, with: :not_found
      NOT_FOUND_MESSAGE = 'not found'.freeze
      SERVER_ERROR_MESSAGE = 'server error'.freeze

      def show
        data = EduroamAuthorize.authorize!(params[:login])
        render json: data
      end

      def not_found
        render status: :not_found, json: { Error: NOT_FOUND_MESSAGE }
      end

      def server_error(err)
        log_error(err)
        render status: :internal_server_error, json: { Error: SERVER_ERROR_MESSAGE }
      end
    end
  end
end
