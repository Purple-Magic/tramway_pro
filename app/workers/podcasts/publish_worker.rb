# frozen_string_literal: true

class Podcasts::PublishWorker < ApplicationWorker
  sidekiq_options queue: :podcast

  def perform(id)
    episode = Podcast::Episode.find id

    episode.podcast.channels.each do |channel|
      Podcasts::PublishService.new(channel, episode).run
    end
  end
end
