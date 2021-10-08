# frozen_string_literal: true

class PodcastsTrailerWorker < ApplicationWorker
  sidekiq_options queue: :podcast

  include BotTelegram::Leopold::Notify

  def perform(id)
    chat_id = BotTelegram::Leopold::ChatDecorator::IT_WAY_PODCAST_ID
    episode = Podcast::Episode.find id
    episode.build_trailer
    unless episode.montage_state == 'trailer_rendered'
      send_notification_to_chat chat_id, notification(:audio_trailer, :rendering_over)
    end
    send_file_to_chat chat_id, episode.trailer.path
  end
end
