module CoursesHelpers
  def associated_title(comment)
    associated = comment.associated
    case comment.associated_type
    when 'Courses::Video'
      "#{associated.model_name.human} #{associated.lesson.topic.position}-#{associated.lesson.position}-#{associated.position} | #{associated.comments.count} comments | #{associated.comments.done.count} comments done | #{associated.duration}"
    when 'Courses::Task'
      "#{associated.model_name.human} #{associated.lesson.topic.position}-#{associated.lesson.position}-#{associated.position} | #{associated.comments.count} comments | #{associated.comments.done.count} comments done"
    end
  end
end
