class Podcasts::Episodes::Montage::CutHighlightsService < Podcasts::Episodes::BaseService
  attr_reader :episode

  def initialize(episode)
    @episode = episode
  end

  def call
    cut_highlights
  end

  private

  def cut_highlights
    episode.highlights.each_with_index do |highlight, index|
      Podcasts::Episodes::Highlights::CutService.new(highlight, episode.converted_file, index).call
    end
  end
end
