class Podcasts::Episodes::Highlights::CutService < Podcasts::Episodes::BaseService
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

  def cut(output)
    raise "You should pick begin and end time for Highlight #{highlight.id}" if !highlight.cut_begin_time.present? && !highlight.cut_end_time.present?

    directory = output.split('/')[0..-2].join('/')
    highlight_output = "#{directory}/#{id}.mp3"
    render_command = write_logs cut_content(
      input: highlight.file.path,
      begin_time: highlight.cut_begin_time,
      end_time: highlight.cut_end_time,
      output: highlight_output
    )
    episode.log_command 'Cut highlights', render_command
    run render_command

    update_file! highlight, highlight_output, :ready_file
  end

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
