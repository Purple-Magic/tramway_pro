# frozen_string_literal: true

class Courses::Topic < ApplicationRecord
  belongs_to :course, class_name: 'Course'

  has_many :lessons, -> { order(:position) }, class_name: 'Courses::Lesson'

  def progress_status
    done_lessons = lessons.active.select { |lesson| lesson.progress_status == :done }
    started_lessons = lessons.active.select { |lesson| lesson.progress_status == :in_progress }
    lessons_with_comments_any = lessons.active.map { |lesson| lesson.videos.active.reject { |video| video.progress_status == :not_started  }.count }.uniq != [0]

    return :done if started_lessons.any? && started_lessons.count == lessons.active.count && started_lessons.count == done_lessons.count
    return :in_progress if (lessons.active.any? && lessons_with_comments_any) || started_lessons.count != done_lessons.count
  end
end
