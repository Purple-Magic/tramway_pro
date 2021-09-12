# frozen_string_literal: true

class Courses::Lesson < ApplicationRecord
  belongs_to :topic, class_name: 'Courses::Topic'

  has_many :videos, -> { order(:position) }, class_name: 'Courses::Video'

  def progress_status
    done_videos = videos_with(status: :done).count
    started_videos = videos_without(status: :ready).count
    conditions = {
      done: lambda do |all, started, done, _with_comments_any|
        started.positive? && started == all && started == done
      end,
      in_progress: lambda do |all, started, done, with_comments_any|
        (all.positive? && with_comments_any) || started != done
      end
    }

    conditions.each do |condition|
      return condition[0] if condition[1].call(videos.active.count, started_videos, done_videos,
        videos_with_comments_any)
    end
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
