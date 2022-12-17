class Podcasts::PublishService < ApplicationService
  include BotTelegram::Leopold::Notify

  def telegram(episode, chat_id)
    send_file_to_chat chat_id, episode.trailer_video.path,
      caption: Podcast::EpisodeDecorator.new(episode).telegram_post_text
  end
end
