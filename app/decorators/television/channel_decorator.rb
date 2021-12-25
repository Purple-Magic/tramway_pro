class Television::ChannelDecorator < Tramway::Core::ApplicationDecorator
  # Associations you want to show in admin dashboard
  # decorate_associations :messages, :posts

  delegate_attributes(
        :id,
        :title,
        :channel_type,
        :rtmp,
        :project_id,
        :created_at,
        :updated_at,
  )

  decorate_associations :schedule_items

  class << self
    def collections
      [ :all ]
    end

    def list_attributes
      [
        :id,
        :title,
        :channel_type,
        :rtmp,
      ]
    end

    def show_attributes
      [
        :id,
        :title,
        :channel_type,
        :rtmp,
        :project_id,
        :created_at,
        :updated_at,
      ]
    end

    def show_associations
      [ :schedule_items ]
    end

    def list_filters
    end
  end
end
