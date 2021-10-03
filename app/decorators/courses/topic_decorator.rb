# frozen_string_literal: true

class Courses::TopicDecorator < Tramway::Core::ApplicationDecorator
  # Associations you want to show in admin dashboard
  decorate_association :course

  decorate_association :lessons, as: :topic

  delegate_attributes(
    :id,
    :course_id,
    :state,
    :position,
    :created_at,
    :updated_at,
    :progress_status
  )

  def title
    "Тема #{object.position} | #{object.title}"
  end

  def link
    ::Tramway::Admin::Engine.routes.url_helpers.record_path(object.id, model: object.class)
  end

  alias name title

  class << self
    def collections
      # [ :all, :scope1, :scope2 ]
      [:all]
    end

    def list_attributes
      %i[
        id
        title
        course_id
        state
      ]
    end

    def show_attributes
      %i[
        id
        title
        course_link
        state
        created_at
        updated_at
      ]
    end

    def show_associations
      [:lessons]
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

  def course_link
    link_to(course.title,
      ::Tramway::Admin::Engine.routes.url_helpers.record_path(object.course_id, model: 'Course'))
  end
end
