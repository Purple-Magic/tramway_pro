# frozen_string_literal: true

module CoursesHelpers
  def associated_title(comment)
    associated = comment.associated
    associated_position = "#{associated.lesson.topic.position}-#{associated.lesson.position}-#{associated.position}"
    associated_comments = "#{associated.comments.count} comments | #{associated.comments.done.count} comments done"
    common_part = "#{associated.model_name.human} | #{associated_position} | #{associated_comments}"
    case comment.associated_type
    when 'Courses::Video'
      "#{common_part} | #{associated.duration}"
    when 'Courses::Task'
      common_part
    end
  end
end
