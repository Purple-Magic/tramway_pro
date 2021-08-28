# frozen_string_literal: true

class Courses::Lesson < ApplicationRecord
  belongs_to :topic, class_name: 'Courses::Topic'

  has_many :videos, -> { order(:position) }, class_name: 'Courses::Video'

  def progress_status
    done_videos = videos_with status: :done
    started_videos = videos_without status: :ready
    if started_videos.any? && started_videos.count == videos.active.count && started_videos.count == done_videos.count
      return :done
    end
    return :in_progress if (videos.active.any? && videos_with_comments_any) || started_videos.count != done_videos.count
  end

  def videos_with_comments_any
    videos.active.map { |video| video.comments.active.count }.uniq != [0]
  end

  def videos_with(status:)
    videos.active.select { |video| video.progress_status == status }
  end

  def videos_without(status:)
    videos.active.reject { |video| video.progress_status == status }
  end
end
