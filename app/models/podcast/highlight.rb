# frozen_string_literal: true

class Podcast::Highlight < ApplicationRecord
  belongs_to :episode, class_name: 'Podcast::Episode'

  scope :podcast_scope, ->(_user_id) { all }

  enumerize :using_state, in: %i[using not_using], default: :not_using

  uploader :file, :file
  uploader :ready_file, :file
  uploader :instagram_story, :file

  validate :time_format

  include Podcast::SoundProcessConcern
  include Podcasts::Episodes::TimeManagement
  include Ffmpeg::CommandBuilder

  aasm do
    state :hack
  end

  def directory
    @directory ||= episode.prepare_directory
  end

  def minute
    time.split(':')[1].to_i
  end

  def second
    time.split(':')[2].to_i
  end

  def begin_time
    change_time(time, :minus, 60.seconds)
  end

  def end_time
    change_time(time, :plus, 30.seconds)
  end

  def shift
    episode.parts.sum do |part|
      # if time_less_than highlight.begin_time
    end
  end

  private

  def time_format
    return if time.match(/\d\d:\d\d:\d\d/) && minute < 60 && second < 60

    errors.add(:time, 'invalid')
  end
end
