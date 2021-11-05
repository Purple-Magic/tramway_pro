# frozen_string_literal: true

require 'fileutils'

# :reek:MissingSafeMethod { exclude: [ update_file! ] }
class Podcast::Episode < ApplicationRecord
  EPISODE_ATTRIBUTES = %i[title season number description published_at image explicit file_url duration].freeze

  belongs_to :podcast, class_name: 'Podcast'
  has_many :highlights, -> { order(:time) }, class_name: 'Podcast::Highlight'
  has_many :topics, -> { order(:created_at) }, class_name: 'Podcast::Episodes::Topic'
  has_many :links, class_name: 'Podcast::Episodes::Link'
  has_many :instances, class_name: 'Podcast::Episodes::Instance'
  has_many :stars, class_name: 'Podcast::Episodes::Star'
  has_many :shortened_urls, class_name: '::Shortener::ShortenedUrl', as: :owner

  enumerize :montage_process, in: [ :default, :without_filters ], default: :default

  scope :podcast_scope, ->(_user_id) { all }

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
       video_trailer_is_ready finished published].each { |state_name| state state_name }

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

    event :download do
      transitions to: :downloaded

      after do
        save!
        PodcastsDownloadWorker.perform_async id
      end
    end

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

    event :render_video do
      transitions to: :finishing

      after do
        save!
        PodcastsRenderVideoWorker.perform_async id
      end
    end

    event :publish do
      transitions to: :published

      after do
        save!
        PodcastsPublishWorker.perform_async id
      end
    end
  end

  include Ffmpeg::CommandBuilder
  include Podcast::SoundProcessConcern
  include Podcast::PathManagementConcern
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
    FileUtils.mkdir_p PODCASTS_DIRECTORY

    FileUtils.mkdir_p current_podcast_directory
    parts_directory_name.tap do |dir|
      FileUtils.mkdir_p dir
    end
  end

  def converted_file
    file.path.split('.')[0..].join('.')
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
