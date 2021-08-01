# frozen_string_literal: true

class PodcastsMontageJob < ActiveJob::Base
  queue_as :podcast
  sidekiq_options backtrace: 20

  def perform(id)
    episode = Podcast::Episode.find id
    episode.montage
  rescue StandardError => e
    Rails.env.development? ? puts(e) : Raven.capture_exception(e)
  end
end
