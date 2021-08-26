# frozen_string_literal: true

class Courses::LessonDecorator < Tramway::Core::ApplicationDecorator
  # Associations you want to show in admin dashboard
  decorate_association :topic

  decorate_association :videos, as: :lesson

  delegate_attributes(
    :id,
    :topic_id,
    :state,
    :position,
    :created_at,
    :updated_at,
    :progress_status
  )

  def title
    "#{topic.position}-#{object.position}  | #{object.title}"
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
        topic
        state
      ]
    end

    def show_attributes
      %i[
        id
        title
        state
        topic_link
        created_at
        updated_at
      ]
    end

    def show_associations
      [
        :videos
      ]
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

  def topic_link
    link_to(topic.title,
      ::Tramway::Admin::Engine.routes.url_helpers.record_path(object.topic_id, model: 'Courses::Topic'))
  end
end
