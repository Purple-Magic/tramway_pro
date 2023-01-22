# frozen_string_literal: true

class Podcasts::TrailerWorker < ApplicationWorker
  sidekiq_options queue: :podcast

  include BotTelegram::Leopold::Notify

  def perform(id)
    episode = Podcast::Episode.find id
    Podcasts::Episodes::Montage::AudioTrailerService.new(episode).call
    send_notification_to_chat episode.podcast.chat_id, notification(:audio_trailer, :success)
  end
end
