# frozen_string_literal: true

require 'fileutils'

class Podcast::Episode < ApplicationRecord
  EPISODE_ATTRIBUTES = %i[title season number description published_at image explicit file_url duration].freeze

  belongs_to :podcast, class_name: 'Podcast'
  has_many :highlights, -> { order(:time) }, class_name: 'Podcast::Highlight'

  uploader :ready_file, :file
  uploader :file, :file
  uploader :cover, :photo
  uploader :premontage_file, :file
  uploader :trailer, :file
  uploader :trailer_video, :file
  uploader :full_video, :file

  aasm :montage, column: :montage_state do
    state :recording, initial: true
    state :recorded
    state :downloaded
    state :converted
    state :prepared
    state :highlighted
    state :montaged
    state :normalized
    state :music_added
    state :trailer_is_ready
    state :trailer_rendered
    state :concatination_in_progress
    state :finishing
    state :ready_audio
    state :video_trailer_is_ready
    state :finished

    event :download do
      transitions to: :downloaded
    end

    event :convert do
      transitions to: :converted
    end

    event :highlight_it do
      transitions to: :highlighted
    end

    event :finish_record do
      transitions to: :recorded

      after do
        save!
        Podcasts::MontageWorker.perform_async id
      end
    end

    event :prepare do
      transitions to: :prepared
    end

    event :to_montage do
      transitions to: :montaged
    end

    event :to_normalize do
      transitions to: :normalized
    end

    event :music_add do
      transitions to: :music_added
    end

    event :trailer_get_ready do
      transitions to: :trailer_is_ready

      after do
        save!
        Podcasts::TrailerWorker.perform_async id
      end
    end

    event :trailer_finish do
      transitions to: :trailer_rendered
    end

    event :make_audio_ready do
      transitions to: :ready_audio
    end

    event :finish do
      transitions to: :finishing

      after do
        save!
        Podcasts::FinishWorker.perform_async id
      end
    end

    event :make_video_trailer_ready do
      transitions to: :video_trailer_is_ready
    end

    event :done do
      transitions to: :finished
    end
  end

  include Podcast::Episodes::DescriptionConcern
  include Podcast::Episodes::HighlightsConcern
  include Podcast::Episodes::MusicConcern
  include Podcast::Episodes::TrailerConcern
  include Podcast::Episodes::VideoConcern

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

  def montage(filename, output)
    temp_output = (output.split('.')[0..-2] + %w[temp mp3]).join('.')
    render_command = use_filters(input: filename, output: temp_output)
    move_command = move_to(temp_output, output)
    command = "#{render_command} && #{move_command}"
    Rails.logger.info command
    system command
  end

  def move_to(temp_output, output)
    "mv #{temp_output} #{output}"
  end

  def converted_file
    file.path.split('.')[0..].join('.')
  end

  def convert_file
    filename = converted_file

    if file.path.split('.').last == 'ogg'
      filename += '.mp3'
      command = convert_to :mp3, input: file.path, output: filename
      Rails.logger.info command
      system command
    end

    filename
  end

  def update_file!(output, file_type)
    File.open(output) do |f|
      send "#{file_type}=", f
    end
    save!
  end

  private

  def podcasts_directory
    "/#{Rails.root}/public/podcasts/"
  end

  def current_podcast_directory
    "#{podcasts_directory}#{podcast.title.gsub(' ', '_')}/"
  end
end
