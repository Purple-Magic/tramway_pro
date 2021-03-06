# frozen_string_literal: true

class Estimation::TaskDecorator < Tramway::Core::ApplicationDecorator
  # Associations you want to show in admin dashboard
  # decorate_associations :messages, :posts

  delegate_attributes(
    :id,
    :title,
    :hours,
    :price,
    :created_at,
    :updated_at,
    :specialists_count,
    :sum
  )

  include Estimation::TaskConcern

  def description
    content_tag :span, style: 'font-size: 12px' do
      object.description
    end
  end

  class << self
    def collections
      [:all]
    end

    def list_attributes
      %i[
        id
        title
        hours
        price
      ]
    end

    def show_attributes
      %i[
        id
        title
        hours
        price
        specialists_count
        description
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
