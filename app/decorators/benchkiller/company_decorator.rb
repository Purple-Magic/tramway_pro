class Benchkiller::CompanyDecorator < Tramway::Core::ApplicationDecorator
  # Associations you want to show in admin dashboard
  # decorate_associations :messages, :posts

  delegate_attributes(
    :id,
    :title,
    :data,
    :state,
    :project_id,
    :created_at,
    :updated_at,
    :portfolio_url,
    :company_url,
    :email,
    :place,
    :phone,
    :regions_to_cooperate
  )

  def bot_card
    <<-TXT
Название: #{title}

Сайт: #{company_url}

Портфолио: #{portfolio_url}

Почта: #{email}

Телефон: #{phone}

Регион: #{place}

Регион работы: #{regions_to_cooperate}
    TXT
  end

  class << self
    def collections
      # [ :all, :scope1, :scope2 ]
      [ :all ]
    end

    def list_attributes
      [
        :id,
        :title,
        :data,
        :state,
      ]
    end

    def show_attributes
      [
        :id,
        :title,
        :data,
        :state,
        :project_id,
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
