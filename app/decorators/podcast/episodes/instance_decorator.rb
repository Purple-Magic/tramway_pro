# frozen_string_literal: true

class Podcast::Episodes::InstanceDecorator < Tramway::Core::ApplicationDecorator
  # Associations you want to show in admin dashboard
  decorate_associations :episode

  delegate_attributes(
    :id,
    :state,
    :project_id,
    :service,
    :link,
    :created_at,
    :updated_at
  )

  def title
    "#{object.service} ссылка эпизода ##{object.episode.number}"
  end

  def shortened_url
    "http://it-way.pro/#{object.shortened_urls.last.unique_key}"
  end

  def episode_link
    link_to episode.title,
      ::Tramway::Admin::Engine.routes.url_helpers.record_path(object.episode_id, model: 'Podcast::Episode')
  end

  class << self
    def collections
      # [ :all, :scope1, :scope2 ]
      [:all]
    end

    def list_attributes
      %i[
        id
        state
        project_id
        service
      ]
    end

    def show_attributes
      %i[
        episode_link
        id
        shortened_url
        project_id
        service
        link
        created_at
        updated_at
      ]
    end

    def show_associations
      []
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
