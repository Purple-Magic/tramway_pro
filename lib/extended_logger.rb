# frozen_string_literal: true

module ExtendedLogger
  def log_error(error)
    Rails.env.development? ? Rails.logger.error("logger.info : #{error.message}") : Airbrake.notify(error)
  end
end
