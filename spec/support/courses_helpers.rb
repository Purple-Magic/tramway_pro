# frozen_string_literal: true

module CoursesHelpers
  def associated_title(comment)
    case comment.associated_type
    when 'Courses::Video'
      video_title comment.associated
    when 'Courses::Task'
      task_title comment.associated
    end
  end

  def common_part(object)
    position = "#{object.lesson.topic.position}-#{object.lesson.position}-#{object.position}"
    comments = "#{object.comments.count} comments | #{object.comments.done.count} comments done"
    "#{object.model_name.human} #{position} | #{comments}"
  end

  def video_title(video)
    "#{common_part(video)} | #{video.duration}"
  end

  def task_title(task)
    common_part task
  end

  def lesson_title(lesson)
    "#{lesson.model_name.human} #{lesson.topic.position}-#{lesson.position} | #{lesson.title}"
  end
end
