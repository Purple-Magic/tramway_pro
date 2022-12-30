class Podcasts::Episodes::Montage::AudioTrailerService < Podcasts::Episodes::BaseService
  attr_reader :episode

  def initialize(episode)
    @episode = episode
  end
  
  def call
    build_trailer
  end

  private

  def build_trailer
    output = "#{episode.prepare_directory.gsub('//', '/')}/trailer.mp3"

    cut_using_highlights output

    render_trailer output
    episode.update_file! output, :trailer

    normalize_trailer output
    episode.update_file! output, :trailer

    episode.trailer_finish!
  end

  def normalize_trailer(output)
    temp_output = update_output :normalize, output
    render_command = write_logs normalize(input: episode.trailer.path, output: temp_output)
    move_command = move_to(temp_output, output)
    command = "#{render_command} && #{move_command}"
    Rails.logger.info command
    _log, _err, _status = Open3.capture3({}, command, {})
  end

  def render_trailer(output)
    temp_output = update_output :temp, output
    render_command = write_logs(content_concat(inputs: content, output: temp_output))
    move_command = move_to(temp_output, output)
    command = "#{render_command} && #{move_command}"
    Rails.logger.info command
    _log, _err, _status = Open3.capture3({}, command, {})
  end

  def using_highlights
    @collection ||= episode.highlights.where(using_state: :using).order(:trailer_position)
    @collection.tap do
      raise 'You should pick some highlights as using' unless @collection.any?
    end
  end

  def cut_using_highlights(output)
    using_highlights.each do |highlight|
      Podcasts::Episodes::Highlights::CutService.new(highlight, output).call
    end
  end

  def files_inputs(using_highlights)
    trailer_separator = podcast.musics.where(music_type: :trailer_separator).first.file.path
    @files_inputs ||= using_highlights.map do |highlight|
      [highlight.ready_file.path, trailer_separator]
    end.flatten
  end

  def build_and_runcommand(files_inputs, output)
    temp_output = (output.split('.')[0..-2] + %w[temp mp3]).join('.')

    render_command = content_concat inputs: files_inputs, output: temp_output
    move_command = move_to(temp_output, output)
    command = "#{render_command} && #{move_command}"
    Rails.logger.info command
    _log, _err, _status = Open3.capture3({}, command, {})
  end

  def content
    using_highlights.sort_by(&:trailer_position).map do |content_file|
      [content_file.ready_file.path, episode.podcast.trailer_separator.file.path]
    end.flatten
  end
end
