# frozen_string_literal: true

module Podcast::Episodes::FilesConcern
  def parts_directory_name
    "#{current_podcast_directory}/#{id}/"
  end

  def prepare_directory
    FileUtils.mkdir_p PODCASTS_DIRECTORY

    FileUtils.mkdir_p current_podcast_directory
    parts_directory_name.tap do |dir|
      FileUtils.mkdir_p dir
    end
  end

  def converted_file
    file.present? ? file.path.split('.')[0..].join('.') : ''
  end

  def convert_file
    filename = converted_file

    if file.path.split('.').last == 'ogg'
      filename += '.mp3'
      command = write_logs(convert_to(:mp3, input: file.path, output: filename))
      Rails.logger.info command
      system command
    end

    filename.tap do
      wait_for_file_rendered filename, :convert

      convert!
    end
  end

  private

  PODCASTS_DIRECTORY = "/#{Rails.root}/public/podcasts/"

  def current_podcast_directory
    "#{PODCASTS_DIRECTORY}#{podcast.title.gsub(' ', '_')}/"
  end
end
