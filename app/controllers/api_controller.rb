class ApiController < ApplicationController
  rescue_from StandardError, with: :server_error

  def server_error(err)
    log_error(err)
    head 500
  end
end
