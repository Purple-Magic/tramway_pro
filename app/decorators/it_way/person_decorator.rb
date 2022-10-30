class ItWay::PersonDecorator < Tramway::Core::ApplicationDecorator
  delegate_attributes(
        :id,
        :first_name,
        :last_name,
        :avatar,
        :state,
        :deleted_at,
        :project_id,
        :created_at,
        :updated_at,
  )

  decorate_associations :participations

  def title
    "#{first_name} #{last_name}"
  end

  class << self
    def collections
      # [ :all, :scope1, :scope2 ]
      [ :all ]
    end

    def list_attributes
      [
        :id,
        :first_name,
        :last_name,
        :avatar,
      ]
    end

    def show_attributes
      [
        :id,
        :first_name,
        :last_name,
        :avatar,
        :state,
        :deleted_at,
        :project_id,
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
