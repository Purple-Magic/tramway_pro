# frozen_string_literal: true

module Courses::DecoratorHelpers::Tree
  def topic_row(topic)
    concat(content_tag(:li) do
      concat(link_to(topic.title, topic.link, class: topic.progress_status))
      concat(content_tag(:ul) do
        topic.lessons.each do |lesson|
          lesson_row lesson
        end
      end)
    end)
  end

  def lesson_row(lesson)
    concat(content_tag(:li) do
      concat(link_to(lesson.title, lesson.link, class: lesson.progress_status))
      concat(content_tag(:ul) do
        (lesson.videos + lesson.tasks).sort_by(&:position).each do |item|
          case item.model.class.to_s
          when 'Courses::Video'
            video_row item
          when 'Courses::Task'
            task_row item
          end
        end
      end)
    end)
  end

  def video_row(video)
    concat(content_tag(:li, class: :bottom) do
      link_to video.link, class: video.progress_status do
        concat(content_tag(:span) do
          video.title
        end)
        concat(content_tag(:span) do
          video.release_date
        end)
      end
    end)
  end

  def task_row(task)
    concat(content_tag(:li, class: :bottom) do
      link_to task.link, class: task.progress_status do
        concat(content_tag(:span) do
          task.title
        end)
      end
    end)
  end
end
