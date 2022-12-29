class Podcasts::Episodes::CutHighlightsService < Podcasts::Episodes::BaseService
  attr_reader :episode

  def initialize(episode)
    @episode = episode
  end

  def call
    cut_highlights
  end

  private

  def cut_highlights
    filename = Podcasts::Episodes::ConvertService.new(episode).call
    highlights.each_with_index do |highlight, index|
      Podcasts::Episodes::Highlights::CutService.new(highlight, filename, index).call
    end
  end
end
