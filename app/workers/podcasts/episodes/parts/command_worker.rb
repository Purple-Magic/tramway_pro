# frozen_string_literal: true

class Podcasts::Episodes::Parts::CommandWorker < ApplicationWorker
  sidekiq_options queue: :podcast

  def perform(command)
    Rails.logger.info command
    system command
  rescue StandardError => error
    Rails.env.development? ? puts(error) : Airbrake.notify(error)
  end
end
