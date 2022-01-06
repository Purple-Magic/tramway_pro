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

  def common_part(_object)
    position = "#{lesson.lesson.topic.position}-#{lesson.lesson.position}-#{lesson.position}"
    comments = "#{lesson.comments.count} comments | #{lesson.comments.done.count} comments done"
    "#{lesson.model_name.human} | #{position} | #{comments}"
  end

  def video_title(video)
    "#{common_part(video)} | #{video.duration}"
  end

  def task_title(task)
    common_part task
  end

  def lesson_title(lesson)
    "#{lesson.model_name.human} #{topic.position}-#{lesson.position} | #{lesson.title}"
  end
end
