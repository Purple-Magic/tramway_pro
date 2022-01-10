class Courses::ScreencastDecorator < Tramway::Core::ApplicationDecorator
  # Associations you want to show in admin dashboard
  # decorate_associations :messages, :posts

  delegate_attributes(
        :id,
        :project_id,
        :video_id,
        :scenario,
        :created_at,
        :updated_at,
  )

  def title
    "Screencast #{object.id} of Video ##{object.video_id}"
  end

  def scenario
    raw object.scenario.gsub("\n", '<br/>')
  end

  include Webpacker::Helper

  def preview
    content_tag(:div) do
      concat(content_tag(:span, id: :scenario, style: 'display: none') do
        object.scenario
      end)
      concat(content_tag(:div, id: :terminal) {})
      concat(content_tag(:span, id: :timer) {})
      concat javascript_pack_tag :application
    end
  end

  class << self
    def collections
      [ :all ]
    end

    def list_attributes
      [
        :id,
        :project_id,
        :video_id,
        :scenario,
      ]
    end

    def show_attributes
      [
        :id,
        :project_id,
        :video_id,
        :scenario,
        :preview,
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
