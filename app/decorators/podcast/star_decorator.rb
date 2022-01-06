# frozen_string_literal: true

class Podcast::StarDecorator < ApplicationDecorator
  # Associations you want to show in admin dashboard
  # decorate_associations :messages, :posts

  delegate_attributes(
    :id,
    :nickname,
    :link,
    :podcast_id,
    :created_at,
    :updated_at,
    :vk,
    :twitter,
    :instagram,
    :telegram
  )

  decorate_associations :podcast

  alias title nickname

  def podcast_link
    link_to podcast.title,
      ::Tramway::Admin::Engine.routes.url_helpers.record_path(object.podcast_id, model: 'Podcast')
  end

  class << self
    def collections
      # [ :all, :scope1, :scope2 ]
      [:all]
    end

    def list_attributes
      %i[
        id
        nickname
        link
        podcast_id
      ]
    end

    def show_attributes
      %i[
        podcast_link
        nickname
        link
        vk
        twitter
        instagram
        telegram
        podcast_id
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
