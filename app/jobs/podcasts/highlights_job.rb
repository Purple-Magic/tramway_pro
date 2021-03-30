module Podcasts
  class HighlightsJob < ActiveJob::Base
    queue_as :default

    def perform(*args)
      episode = Podcast::Episode.find id
      episode.cut_highlights
    end
  end
end
