# frozen_string_literal: true

class PodcastsHighlightsJob < ActiveJob::Base
  queue_as :default

  def perform(id)
    episode = Podcast::Episode.find id
    episode.cut_highlights
    episode.highlight_it
  rescue StandardError
    Rails.env.development? ? puts(e) : Raven.capture_exception(e)
  end
end
