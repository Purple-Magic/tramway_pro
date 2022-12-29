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
    (file.present? ? file.path.split('.')[0..].join('.') : '') + '.mp3'
  end

  private

  PODCASTS_DIRECTORY = "/#{Rails.root}/public/podcasts/"

  def current_podcast_directory
    "#{PODCASTS_DIRECTORY}#{podcast.title.gsub(' ', '_')}/"
  end
end
