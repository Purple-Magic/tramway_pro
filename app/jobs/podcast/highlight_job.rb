class Podcast::HighlightJob < ApplicationJob
  def perform(id)
    episode = Podcast::Episode.find id
    episode.cut_highlights
  end
end
