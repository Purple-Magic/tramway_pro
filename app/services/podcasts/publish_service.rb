class Podcasts::PublishService < ApplicationService
  include BotTelegram::Leopold::Notify

  attr_reader :episode, :channel

  def initialize(channel, episode)
    @episode = episode
    @channel = channel
  end

  def run
    public_send service
  end

  def telegram
    public_send "send_file_to_#{channel.options.chat_type}", channel_id, episode.trailer_video.path,
      caption: Podcast::EpisodeDecorator.new(episode).telegram_post_text
  end
end
