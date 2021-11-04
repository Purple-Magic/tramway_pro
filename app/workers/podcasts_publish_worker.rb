class PodcastsPublishWorker < ApplicationWorker
  sidekiq_options queue: :podcast

  include BotTelegram::Leopold::Notify

  def perform(id)
    episode = Podcast::Episode.find id

    chat_id = BotTelegram::Leopold::ChatDecorator::IT_WAY_PODCAST_ID
    send_notification_to_chat chat_id, ::Podcast::EpisodeDecorator.new(episode).telegram_post_text
  end
end
