class Products::TaskDecorator < Tramway::Core::ApplicationDecorator
  delegate_attributes(
        :title,
        :data,
        :created_at,
        :card_id
  )

  decorate_association :time_logs, as: :associated

  def created_at
    object.created_at.strftime('%d.%m.%Y %H:%M')
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
        :card_id,
        :data,
        :created_at,
      ]
    end

    def show_associations
      [ :time_logs ]
    end
  end
end
