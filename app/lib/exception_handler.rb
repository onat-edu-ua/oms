module ExceptionHandler
  extend ActiveSupport::Concern

  class_methods do
    def log_error(error, backtrace: true)
      logger.error do
        msg = "<#{error.class}>: #{error.message}"
        msg << "\n#{error.backtrace.join("\n")}" if backtrace
        msg
      end
      if error.cause && error != error.cause
        logger.error { 'Caused by:' }
        log_error(error.cause, backtrace: backtrace)
      end
    end
  end

  def log_error(error, backtrace: true)
    self.class.log_error(error, backtrace: backtrace)
  end
end
