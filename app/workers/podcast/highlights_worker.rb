module Podcast
  class HighlightsWorker
    include Sidekiq::Worker

    def perform(*args)
      episode = Podcast::Episode.find id
      episode.cut_highlights
    end
  end
end
