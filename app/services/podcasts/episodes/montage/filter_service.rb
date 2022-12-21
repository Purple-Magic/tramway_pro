class Podcasts::Episodes::Montage::FilterService < Podcasts::Episodes::BaseService
  attr_reader :episode

  def initialize(episode)
    @episode = episode
  end

  def call
    filter
  end

  private

  def filter
    output = episode.premontage_file.path
    if episode.montage_process == 'default'
      directory = episode.prepare_directory.gsub('//', '/')
      output = "#{directory}/montage.mp3"
      temp_output = (output.split('.')[0..-2] + %w[temp mp3]).join('.')

      build_and_run_command filename, output, temp_output
    end

    wait_for_file_rendered output, :montage
    update_file! output, :premontage_file
    prepare!
  end

  def build_and_run_command
    render_command = write_logs use_filters(input: filename, output: temp_output)
    move_command = move_to(temp_output, output)
    command = "#{render_command} && #{move_command}"
    log_command 'Use filters', command
    Rails.logger.info command
    system command
  end
end
