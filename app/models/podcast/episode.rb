# frozen_string_literal: true

require 'fileutils'

class Podcast::Episode < ApplicationRecord
  EPISODE_ATTRIBUTES = %i[title season number description published_at image explicit file_url duration].freeze

  belongs_to :podcast
  has_many :highlights, class_name: 'Podcast::Highlight'

  uploader :ready_file, :file
  uploader :file, :file
  uploader :cover, :photo
  uploader :premontage_file, :file

  aasm :montage, column: :montage_state do
    state :recording, initial: true
    state :recorded
    state :prepared
    state :highlighted
    state :montaged
    state :finished

    event :highlight_it do
      transitions to: :highlighted
    end

    event :finish_record do
      transitions to: :recorded

      after do
        save!
        PodcastsDownloadExternalFileJob.perform_later self.id
      end
    end

    event :prepare do
      transitions to: :prepared

      after do
        save!
        PodcastsPrepareJob.perform_later self.id
      end
    end

    event :to_montage do
      transitions to: :montaged

      after do
        save!
        PodcastsMontageJob.perform_later self.id
      end
    end

    event :finish do
      transitions to: :finished

      after do
        save!
        PodcastsFinishJob.perform_later self.id
      end
    end
  end

  def cut_highlights
    filename = convert_file

    directory = prepare_directory

    highlights.each_with_index do |highlight, index|
      hour = highlight.time.split(':')[0]
      minutes = highlight.time.split(':')[1]
      seconds = highlight.time.split(':')[2]

      highlight_time = DateTime.new(2020, 0o1, 0o1, hour.to_i, minutes.to_i, seconds.to_i)
      begin_time = (highlight_time - 90.seconds).strftime '%H:%M:%S'
      end_time = (highlight_time + 10.seconds).strftime '%H:%M:%S'
      # TODO: use lib/ffmpeg/builder.rb
      system "ffmpeg -y -i #{filename} -ss #{begin_time} -to #{end_time} -b:a 320k -c copy #{directory}/part-#{index + 1}.mp3"
    end
  end

  include Podcast::EpisodeConcern

  def raw_description
    recursively_build_description Nokogiri::HTML(description).elements
  end

  def parts_directory_name
    "#{current_podcast_directory}/#{number}/"
  end

  def prepare_directory
    FileUtils.mkdir_p podcasts_directory

    FileUtils.mkdir_p current_podcast_directory
    parts_directory_name.tap do |dir|
      FileUtils.mkdir_p dir
    end
  end

  include Ffmpeg::CommandBuilder

  def montage
    filename = convert_file
    Rails.logger.info "FILENAME #{filename}"

    directory = prepare_directory

    # TODO: use lib/ffmpeg/builder.rb
    output = "#{directory}/montage.mp3"
    system "ffmpeg -y -i #{filename} -af silenceremove=stop_periods=-1:stop_duration=1:stop_threshold=-30dB,acompressor=threshold=-12dB:ratio=2:attack=200:release=1000,volume=-0.5dB -c:a libmp3lame -b:a 320k #{output}"

    File.open(output) do |f|
      self.premontage_file = f
    end
    save!
  end

  def converted_file
    filename = file.path.split('.')[0..-1].join('.')
  end

  def convert_file
    filename = converted_file

    filename.tap do
      if file.path.split('.').last == 'ogg'
        filename += '.mp3'
        system "ffmpeg -y -i #{file.path} -c:a libmp3lame #{filename}"
      end
    end
  end

  private

  def podcasts_directory
    "/#{Rails.root}/public/podcasts/"
  end

  def current_podcast_directory
    "#{podcasts_directory}#{podcast.title.gsub(' ', '_')}/"
  end
end
