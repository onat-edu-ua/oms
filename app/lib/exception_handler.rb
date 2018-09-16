module ExceptionHandler
  extend ActiveSupport::Concern

  class_methods do
    def log_error(error, backtrace: true)
      logger.error do
        msg = "<#{error.class}>: #{error.message}"
        msg << "\n#{error.backtrace.join("\n")}" if backtrace
        msg
      end
    end
  end

  def log_error(error, backtrace: true)
    self.class.log_error(error, backtrace: backtrace)
  end
end
