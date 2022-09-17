# frozen_string_literal: true

class Podcasts::PublishWorker < ApplicationWorker
  sidekiq_options queue: :podcast

  include BotTelegram::Leopold::Notify

  def perform(id)
    episode = Podcast::Episode.find id

    podcast_chat_id = BotTelegram::Leopold::ChatDecorator::IT_WAY_PODCAST_ID
    community_chat_id = ::BotTelegram::Leopold::ItWayPro::CHAT_ID
    # [podcast_chat_id, community_chat_id].each do |chat_id|
    [podcast_chat_id].each do |chat_id|
      send_file_to_chat chat_id, episode.trailer_video.path, caption: ::Podcast::EpisodeDecorator.new(episode).telegram_post_text
    end
  end
end
