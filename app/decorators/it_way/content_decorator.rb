class ItWay::ContentDecorator < Tramway::Core::ApplicationDecorator
  delegate_attributes(
        :id,
        :content_type,
        :associated_id,
        :associated_type,
        :deleted_at,
        :state,
        :title,
        :created_at,
        :updated_at,
  )

  decorate_associations :participations

  class << self
    def collections
      # [ :all, :scope1, :scope2 ]
      [ :all ]
    end

    def list_attributes
      [
        :id,
        :content_type,
        :associated_id,
        :associated_type,
      ]
    end

    def show_attributes
      [
        :id,
        :content_type,
        :associated_id,
        :associated_type,
        :deleted_at,
        :state,
        :title,
        :created_at,
        :updated_at,
      ]
    end

    def show_associations
      [ :participations ]
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
