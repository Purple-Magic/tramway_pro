# frozen_string_literal: true

class Courses::Topic < ApplicationRecord
  belongs_to :course, class_name: 'Course'

  has_many :lessons, -> { order(:position) }, class_name: 'Courses::Lesson'

  ::Course::TEAMS.each do |team|
    scope "#{team}_scope".to_sym, lambda { |_user_id|
      where(id: select do |topic|
        topic.course.team == team.to_s
      end.map(&:id))
    }
  end

  validates :position, presence: true

  def progress_status
    done_lessons = lessons_with status: :done
    started_lessons = lessons_with(status: :in_progress).count
    return :done if lessons.count == done_lessons.count

    return :in_progress if (lessons.any? && lessons_with_comments_any) || started_lessons != done_lessons.count
  end

  def lessons_with(status:)
    lessons.select { |lesson| lesson.progress_status == status }
  end

  def lessons_with_comments_any
    lessons.select(&:any_comments?).any?
  end
end
