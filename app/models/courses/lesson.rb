# frozen_string_literal: true

class Courses::Lesson < ApplicationRecord
  belongs_to :topic, class_name: 'Courses::Topic'

  has_many :videos,  -> { order(:position) }, class_name: 'Courses::Video'

  def progress_status
    done_videos = videos.active.select { |video| video.progress_status == :done }
    started_videos = videos.active.reject { |video| video.progress_status == :not_started }
    return :done if started_videos.any? && started_videos.count == done_videos.count
    return :in_progress if started_videos.count != done_videos.count
  end
end
