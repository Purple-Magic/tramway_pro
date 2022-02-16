class Products::TaskDecorator < Tramway::Core::ApplicationDecorator
  delegate_attributes(
        :title,
        :data,
        :created_at,
        :card_id,
        :description,
        :estimation
  )

  decorate_association :product
  decorate_association :time_logs, as: :associated

  include Concerns::TimeLogsTable

  def created_at
    object.created_at.strftime('%d.%m.%Y %H:%M')
  end

  def product_link
    link_to product.title,
      ::Tramway::Admin::Engine.routes.url_helpers.record_path(object.product_id, model: 'Product')
  end

  class << self
    def collections
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
        :product_link,
        :card_id,
        :data,
        :created_at,
        :description,
        :estimation,
        :time_logs_table,
        :time_logs_list
      ]
    end

    def show_associations
      [ :time_logs ]
    end
  end
end
