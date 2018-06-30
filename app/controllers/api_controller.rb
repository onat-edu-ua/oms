class ApiController < ApplicationController
  rescue_from StandardError, with: :server_error

  def server_error(err)
    Rails.logger.error { "<#{err.class}>: #{err.message}\n#{err.backtrace.join("\n")}" }
    head 500
  end
end
