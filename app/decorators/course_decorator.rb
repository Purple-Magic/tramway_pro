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
        tree
        created_at
        updated_at
      ]
    end

    def show_associations
      [:topics]
    end

    def list_filters
      # {
      #   filter_name: {
      #     type: :select,
      #     select_collection: filter_collection,
      #     query: lambda do |list, value|
      #       list.where some_attribute: value
      #     end
      #   },
      #   date_filter_name: {
      #     type: :dates,
      #     query: lambda do |list, begin_date, end_date|
      #       list.where 'created_at > ? AND created_at < ?', begin_date, end_date
      #     end
      #   }
      # }
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
        lesson.videos.each do |video|
          video_row(video)
        end
      end)
    end)
  end

  def video_row(video)
    concat(content_tag(:li, class: :bottom) do
      link_to video.title, video.link, class: video.progress_status
    end)
  end
end
