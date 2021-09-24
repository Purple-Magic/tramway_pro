# frozen_string_literal: true

class Courses::Topic < ApplicationRecord
  belongs_to :course, class_name: 'Course'

  has_many :lessons, -> { order(:position) }, class_name: 'Courses::Lesson'

  def progress_status
    done_lessons = lessons_with status: :done
    started_lessons = lessons_with(status: :in_progress).count
    if lessons.active.count == done_lessons.count
      return :done
    end

    :in_progress if (lessons.active.any? && lessons_with_comments_any) || started_lessons != done_lessons.count
  end

  def lessons_with(status:)
    lessons.active.select { |lesson| lesson.progress_status == status }
  end

  def lessons_with_comments_any
    lessons.active.map do |lesson|
      lesson.videos.active.reject do |video|
        video.progress_status == :not_started
      end.count
    end.uniq != [0]
  end
end
