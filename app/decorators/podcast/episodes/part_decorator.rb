# frozen_string_literal: true

class Podcast::Episodes::PartDecorator < Tramway::Core::ApplicationDecorator
  delegate_attributes(
    :id,
    :episode_id,
    :project_id,
    :deleted_at,
    :begin_time,
    :end_time,
    :created_at,
    :updated_at,
    :preview
  )

  decorate_associations :episode

  include Concerns::AudioControls

  def title
    "#{begin_time}-#{end_time}"
  end

  def preview_file
    audio do
      content_tag(:source, '', src: object.preview.url)
    end
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

    def list_attributes; end

    def show_attributes
      %i[
        episode_link
        preview_file
        begin_time
        end_time
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
