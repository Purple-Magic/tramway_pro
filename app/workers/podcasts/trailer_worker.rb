# frozen_string_literal: true

class Podcasts::TrailerWorker < ApplicationWorker
  sidekiq_options queue: :podcast

  include BotTelegram::Leopold::Notify

  def perform(id)
    episode = Podcast::Episode.find id
    episode.build_trailer
    send_notification_to_chat episode.podcast.chat_id, notification(:audio_trailer, :rendering_over)
    send_file_to_chat episode.podcast.chat_id, episode.trailer.path
  end
end
