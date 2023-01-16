class ItWay::ParticipationDecorator < Tramway::ApplicationDecorator
  # Associations you want to show in admin dashboard
  # decorate_associations :messages, :posts

  delegate_attributes(
        :id,
        :person_id,
        :content_id,
        :state,
        :deleted_at,
        :project_id,
        :role,
        :created_at,
        :updated_at,
  )

  decorate_associations :person, :content

  def title
    "#{person.title} #{role} @ #{content.title}"
  end

  class << self
    def collections
      # [ :all, :scope1, :scope2 ]
      [ :all ]
    end

    def list_attributes
      [
        :id,
        :person_id,
        :content_id,
        :state,
      ]
    end

    def show_attributes
      [
        :id,
        :person_id,
        :content_id,
        :state,
        :deleted_at,
        :project_id,
        :role,
        :created_at,
        :updated_at,
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
