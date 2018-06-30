class ApiController < ApplicationController
  rescue_from StandardError, with: :server_error

  def server_error(e)
    Rails.logger.error { "<#{e.class}>: #{e.message}\n#{e.backtrace.join("\n")}" }
    head 500
  end

end
