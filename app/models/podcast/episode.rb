# frozen_string_literal: true

require 'fileutils'

class Podcast::Episode < ApplicationRecord
  EPISODE_ATTRIBUTES = %i[title season number description published_at image explicit file_url duration].freeze

  belongs_to :podcast, class_name: 'Podcast'
  has_many :highlights, -> { order(:time) }, class_name: 'Podcast::Highlight'

  scope :podcast_scope, -> (_user_id) { all }

  uploader :ready_file, :file
  uploader :file, :file
  uploader :cover, :photo
  uploader :premontage_file, :file
  uploader :trailer, :file
  uploader :trailer_video, :file
  uploader :full_video, :file

  aasm :montage, column: :montage_state do
    state :ready_to_start, initial: true

    %i[recording recorded downloaded converted prepared highlighted montaged normalized music_added
       trailer_is_ready trailer_rendered concatination_in_progress finishing ready_audio
       video_trailer_is_ready finished].each { |s| state s }

    event(:download) { transitions to: :downloaded }
    event(:convert) { transitions to: :converted }
    event(:highlight_it) { transitions to: :highlighted }
    event(:prepare) { transitions to: :prepared }
    event(:to_montage) { transitions to: :montaged }
    event(:to_normalize) { transitions to: :normalized }
    event(:music_add) { transitions to: :music_added }
    event(:trailer_finish) { transitions to: :trailer_rendered }
    event(:make_audio_ready) { transitions to: :ready_audio }
    event(:make_video_trailer_ready) { transitions to: :video_trailer_is_ready }
    event(:done) { transitions to: :finished }

    event :finish_record do
      transitions to: :recorded

      after do
        save!
        PodcastsMontageWorker.perform_async id
      end
    end

    event :trailer_get_ready do
      transitions to: :trailer_is_ready

      after do
        save!
        PodcastsTrailerWorker.perform_async id
      end
    end

    event :finish do
      transitions to: :finishing

      after do
        save!
        PodcastsFinishWorker.perform_async id
      end
    end
  end

  include Ffmpeg::CommandBuilder
  include Podcast::Episodes::DescriptionConcern
  include Podcast::Episodes::HighlightsConcern
  include Podcast::Episodes::MusicConcern
  include Podcast::Episodes::TrailerConcern
  include Podcast::Episodes::VideoConcern
  include Podcast::Episodes::MontageConcern

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
