# frozen_string_literal: true

class PodcastsTrailerWorker < ApplicationWorker
  sidekiq_options queue: :podcast

  def perform(id)
    episode = Podcast::Episode.find id
    episode.build_trailer
  end
end
