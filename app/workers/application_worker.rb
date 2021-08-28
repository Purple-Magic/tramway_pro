# frozen_string_literal: true

class ApplicationWorker
  include Sidekiq::Worker
  include ExtendedLogger

  def notification(process, event, **options)
    I18n.t("podcast_engine.notifications.#{process}.#{event}", **options)
  end
end
