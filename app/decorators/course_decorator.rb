class CourseDecorator < Tramway::Core::ApplicationDecorator
  # Associations you want to show in admin dashboard
  decorate_associations :topics

  delegate_attributes(
        :id,
        :title,
        :state,
        :created_at,
        :updated_at,
  )

  class << self
    def collections
      # [ :all, :scope1, :scope2 ]
      [ :all ]
    end

    def list_attributes
      [
        :id,
        :title,
        :state,
        :created_at,
      ]
    end

    def show_attributes
      [
        :id,
        :title,
        :state,
        :created_at,
        :updated_at,
      ]
    end

    def show_associations
      [ :topics ]
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
