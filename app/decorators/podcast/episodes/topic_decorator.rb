# frozen_string_literal: true

class Podcast::Episodes::TopicDecorator < Tramway::Core::ApplicationDecorator
  # Associations you want to show in admin dashboard
  # decorate_associations :messages, :posts

  delegate_attributes(
    :id,
    :episode_id,
    :title,
    :link,
    :state,
    :project_id,
    :discus_state,
    :timestamp,
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
        episode_id
        title
        link
      ]
    end

    def show_attributes
      %i[
        id
        episode_id
        title
        link
        state
        project_id
        discus_state
        timestamp
        created_at
        updated_at
      ]
    end

    def show_associations
      # Associations you want to show in admin dashboard
      # [ :messages ]
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

  def discus_state_button_color(_event)
    :success
  end
end
