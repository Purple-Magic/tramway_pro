module Podcasts
  def notification(process, event, **options)
    I18n.t("podcast_engine.notifications.#{process}.#{event}", **options)
  end
end
