# frozen_string_literal: true

class Podcasts::PublishWorker < ApplicationWorker
  sidekiq_options queue: :podcast

  def perform(id)
    episode = Podcast::Episode.find id

    episode.podcast.channels.each do |channel|
      Podcasts::PublishService.public_send(episode, channel.channel_id)
    end
  end
end
