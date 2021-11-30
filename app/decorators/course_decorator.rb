# frozen_string_literal: true

class CourseDecorator < Tramway::Core::ApplicationDecorator
  # Associations you want to show in admin dashboard
  decorate_associations :topics

  delegate_attributes(
    :id,
    :title,
    :state,
    :created_at,
    :updated_at
  )

  class << self
    def collections
      # [ :all, :scope1, :scope2 ]
      [:all]
    end

    def list_attributes
      %i[
        id
        title
        state
        created_at
      ]
    end

    def show_attributes
      %i[
        id
        title
        data
        tree
        created_at
        updated_at
      ]
    end

    def show_associations
      [:topics]
    end

    def list_filters; end
  end

  def data
    content_tag :table do
      concat(content_tag(:thead) do
        concat(content_tag(:th) do
          'Количество видео'
        end)
        concat(content_tag(:th) do
          'Продолжительность видео'
        end)
        concat(content_tag(:th) do
          'Количество задач'
        end)
        concat(content_tag(:th) do
          'Продолжительность задач'
        end)
      end)
      concat(content_tag(:tr) do
        concat(content_tag(:td) do
          object.videos.count.to_s
        end)
        concat(content_tag(:td) do
          object.video_duration
        end)
        concat(content_tag(:td) do
          object.tasks.count.to_s
        end)
        concat(content_tag(:td) do
          object.tasks_duration
        end)
      end)
    end
  end

  def tree
    content_tag :div do
      concat stylesheet_link_tag '/assets/kalashnikovisme/courses'
      concat(content_tag(:ul, class: :tree) do
        topics.each do |topic|
          topic_row topic
        end
      end)
    end
  end

  private

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
