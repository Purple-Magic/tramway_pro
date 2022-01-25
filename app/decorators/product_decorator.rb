class ProductDecorator < Tramway::Core::ApplicationDecorator
  delegate_attributes(
        :id,
        :title,
        :state,
        :deleted_at,
        :project_id,
        :created_at,
        :updated_at,
  )

  decorate_association :tasks

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
        :deleted_at,
      ]
    end

    def show_attributes
      [
        :id,
        :title,
        :state,
        :deleted_at,
        :project_id,
        :created_at,
        :updated_at,
      ]
    end

    def show_associations
      [ :tasks ]
    end
  end
end
