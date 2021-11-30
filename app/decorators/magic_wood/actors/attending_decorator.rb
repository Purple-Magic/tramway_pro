# frozen_string_literal: true

class MagicWood::Actors::AttendingDecorator < Tramway::Core::ApplicationDecorator
  # Associations you want to show in admin dashboard
  # decorate_associations :messages, :posts

  delegate_attributes(
    :id,
    :estimation_project_id,
    :actor_id,
    :state,
    :project_id,
    :created_at,
    :updated_at
  )

  decorate_association :actor
  decorate_association :estimation_project

  def title
    "#{actor.title} @ #{estimation_project.title}"
  end

  class << self
    def collections
      # [ :all, :scope1, :scope2 ]
      [:all]
    end

    def list_attributes
      %i[
        id
        estimation_project_id
        actor_id
        state
      ]
    end

    def show_attributes
      %i[
        id
        estimation_project_id
        actor_id
        state
        project_id
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
end
