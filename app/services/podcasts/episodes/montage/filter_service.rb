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

      build_and_run_command episode.premontage_file.path, output
    end

    update_file! episode, output, :premontage_file
    episode.prepare!
  end

  def build_and_run_command(filename, output)
    render_command = write_logs use_filters(input: filename, output: output)
    run render_command, action: :filter
  end
end
