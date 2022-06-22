# frozen_string_literal: true

require 'fileutils'

class Podcast::Episode < ApplicationRecord
  EPISODE_ATTRIBUTES = %i[title season number description published_at image explicit file_url duration].freeze
  WORKER_EVENTS = [
    { event: :download, to: :downloaded, worker: 'Download' },
    { event: :finish_record, to: :recorded, worker: 'Montage' },
    { event: :trailer_get_ready, to: :trailer_is_ready, worker: 'Trailer' },
    { event: :finish, to: :finishing, worker: 'Finish' },
    { event: :render_video_trailer, to: :video_trailer_is_ready, worker: 'RenderVideoTrailer' },
    { event: :render_video, to: :finishing, worker: 'RenderVideo' },
    { event: :publish, to: :published, worker: 'Publish' }
  ].freeze

  belongs_to :podcast, class_name: 'Podcast'
  has_many :parts, -> { order :id }, class_name: 'Podcast::Episodes::Part'
  has_many :highlights, -> { order(:time) }, class_name: 'Podcast::Highlight'
  has_many :topics, -> { order(:created_at) }, class_name: 'Podcast::Episodes::Topic'
  has_many :links, class_name: 'Podcast::Episodes::Link'
  has_many :instances, class_name: 'Podcast::Episodes::Instance'
  has_many :stars, class_name: 'Podcast::Episodes::Star'
  has_many :shortened_urls, class_name: '::Shortener::ShortenedUrl', as: :owner
  has_many :time_logs, class_name: 'TimeLog', as: :associated

  enumerize :montage_process, in: %i[default without_filters], default: :default

  scope :podcast_scope, ->(_user_id) { all }

  uploader :file, :file
  uploader :ready_file, :file
  uploader :cover, :photo
  uploader :story_cover, :photo
  uploader :premontage_file, :file
  uploader :trailer, :file
  uploader :trailer_video, :file
  uploader :story_trailer_video, :file
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

    WORKER_EVENTS.each do |worker_event|
      event worker_event[:event] do
        transitions to: worker_event[:to]
        after do
          save!
          "Podcasts::#{worker_event[:worker]}Worker".constantize.perform_async id
        end
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
  include Podcast::Episodes::FilesConcern

  def with_guests?
    stars.guest.any?
  end

  def with_minor?
    stars.minor.any?
  end

  def log_command(command)
    commands = (render_data&.dig('commands') || []) + [command]
    render_data ? render_data['commands'] = commands : self.render_data = { commands: commands }
    save!
  end
end
