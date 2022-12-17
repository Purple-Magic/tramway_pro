class Podcasts::PublishService < ApplicationService
  include BotTelegram::Leopold::Notify

  attr_reader :episode, :service, :channel_id

  def initialize(service, episode, channel_id)
    @episode = episode
    @service = service
    @channel_id = channel_id
  end

  def run
    public_send service
  end

  def telegram
    send_file_to_chat channel_id, episode.trailer_video.path,
      caption: Podcast::EpisodeDecorator.new(episode).telegram_post_text
  end
end
