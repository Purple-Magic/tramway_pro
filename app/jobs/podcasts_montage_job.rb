# frozen_string_literal: true

class PodcastsMontageJob < ActiveJob::Base
  queue_as :default

  def perform(id)
    episode = Podcast::Episode.find id
    episode.montage
    episode.cut_highlights
    episode.highlight_it
  rescue StandardError => e
    Rails.env.development? ? puts(e) : Raven.capture_exception(e)
  end
end
