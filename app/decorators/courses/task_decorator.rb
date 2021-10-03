# frozen_string_literal: true

class Courses::TaskDecorator < Tramway::Core::ApplicationDecorator
  # Associations you want to show in admin dashboard
  # decorate_associations :messages, :posts

  delegate_attributes(
    :id,
    :position,
    :text,
    :max_time,
    :min_time,
    :created_at,
    :updated_at,
    :progress_status
  )

  decorate_association :lesson

  def title
    "Задание #{lesson.topic.position}-#{lesson.position}-#{position}"
  end

  class << self
    def collections
      # [ :all, :scope1, :scope2 ]
      [:all]
    end

    def list_attributes
      %i[
        id
        position
        text
        max_time
      ]
    end

    def show_attributes
      %i[
        id
        position
        text
        max_time
        min_time
        created_at
        updated_at
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

  def link
    ::Tramway::Admin::Engine.routes.url_helpers.record_path(object.id, model: object.class)
  end

  # :reek:ControlParameter { enabled: false }
  def preparedness_state_button_color(event)
    case event
    when :finish_writing
      :primary
    when :upload
      :success
    end
  end
  # :reek:ControlParameter { enabled: true }
end
