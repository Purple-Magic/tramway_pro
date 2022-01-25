class Products::TaskDecorator < Tramway::Core::ApplicationDecorator
  delegate_attributes(
        :id,
        :title,
        :data,
        :created_at,
        :updated_at,
  )

  decorate_association :time_logs, as: :associated

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
        :id,
        :title,
        :data,
        :state,
        :deleted_at,
        :project_id,
        :created_at,
        :updated_at,
      ]
    end

    def show_associations
      [ :time_logs ]
    end
  end
end
