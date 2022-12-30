class Podcasts::Episodes::Highlights::CutService < Podcasts::Episodes::BaseService
  attr_reader :highlight, :episode, :output

  def initialize(highlight, output)
    @highlight = highlight
    @episode = highlight.episode
    @output = output
  end

  def call
    cut
  end

  private

  def cut
    raise "You should pick begin and end time for Highlight #{highlight.id}" if !highlight.cut_begin_time.present? && !highlight.cut_end_time.present?

    directory = output.split('/')[0..-2].join('/')
    highlight_output = "#{directory}/#{highlight.id}.mp3"
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
end
