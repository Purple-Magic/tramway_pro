# frozen_string_literal: true

class PodcastsHighlightsJob < ActiveJob::Base
  queue_as :default

  def perform(id)
    episode = Podcast::Episode.find id
    episode.cut_highlights
  end
end
