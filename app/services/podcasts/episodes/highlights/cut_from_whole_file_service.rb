class Podcasts::Episodes::Highlights::CutFromWholeFileService < Podcasts::Episodes::BaseService
  attr_reader :highlight, :filename, :index, :episode

  def initialize(highlight, filename, index)
    @highlight = highlight
    @filename = filename
    @index = index
    @episode = highlight.episode
  end

  def call
    cut_from_whole_file
  end

  private

  def cut_from_whole_file
    output = "#{episode.directory}/part-#{index + 1}.mp3"
    command = write_logs cut_content input: filename,
      begin_time: highlight.begin_time,
      end_time: highlight.end_time,
      output: output
    run command, action: :cut_highlights
    update_file! highlight, output, :file
  end
end
