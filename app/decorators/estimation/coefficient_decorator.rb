# frozen_string_literal: true

class Estimation::CoefficientDecorator < ApplicationDecorator
  # Associations you want to show in admin dashboard
  # decorate_associations :messages, :posts

  delegate_attributes(
    :id,
    :estimation_project_id,
    :state,
    :scale,
    :created_at,
    :updated_at,
    :position,
    :coefficient_type
  )

  def title
    "#{object.position} | #{object.title} #{object.scale}"
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
        state
        scale
      ]
    end

    def show_attributes
      %i[
        id
        estimation_project_id
        state
        scale
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
