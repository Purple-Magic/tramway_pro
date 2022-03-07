# frozen_string_literal: true

class ApplicationWorker
  include Sidekiq::Worker
  include ExtendedLogger
  include Podcasts

  def show(error)
    case Rails.env.to_sym
    when :development
      puts error
    when :test
      raise error
    else
      Airbrake.notify error
    end
  end
end
