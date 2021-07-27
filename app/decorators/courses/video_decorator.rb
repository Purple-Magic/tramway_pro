# frozen_string_literal: true

class Courses::VideoDecorator < Tramway::Core::ApplicationDecorator
  # Associations you want to show in admin dashboard
  decorate_association :comments, as: :video

  delegate_attributes(
    :id,
    :lesson_id,
    :text,
    :state,
    :position,
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
        lesson_id
        text
        state
      ]
    end

    def show_attributes
      %i[
        id
        lesson_id
        text
        state
        created_at
        updated_at
      ]
    end

    def show_associations
      [:comments]
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

  def title
    "#{object.position} | Video ##{object.id} for Lesson #{object.lesson_id}"
  end

  alias name title
end
