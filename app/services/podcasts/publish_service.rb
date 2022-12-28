class Podcasts::PublishService < ApplicationService
  include BotTelegram::Leopold::Notify

  attr_reader :episode, :channel

  def initialize(channel, episode)
    @episode = episode
    @channel = channel
  end

  def run
    public_send channel.service
  end

  def telegram
    raise "You should set chat_type for Channel with id: #{channel.id}" unless channel.chat_type.present?

    public_send "send_file_to_#{channel.chat_type}", channel.channel_id, episode.trailer_video.path,
      caption: Podcast::EpisodeDecorator.new(episode).telegram_post_text(channel)
  end
end
