# frozen_string_literal: true

class Content::StoryDecorator < Tramway::Core::ApplicationDecorator
  # Associations you want to show in admin dashboard
  # decorate_associations :messages, :posts

  delegate_attributes(
    :id,
    :converting_state,
    :state,
    :project_id,
    :created_at,
    :updated_at
  )

  def title
    "#{object.original_file.file.filename} | #{created_at.strftime('%d.%m.%Y %H:%M')}"
  end

  def original_file
    file_view object.original_file
  end

  def story
    file_view object.story
  end

  def additional_buttons
    path_helpers = Rails.application.routes.url_helpers
    convert_url = path_helpers.red_magic_api_v1_content_story_path(id: id, process: :convert)
    {
      show: [
        { url: convert_url, method: :patch, inner: -> { 'Convert' }, color: :success }
      ]
    }
  end

  def converting_state_button_color(event)
    case event
    when :convert
      :success
    when :make_done
      :success
    end
  end

  class << self
    def collections
      # [ :all, :scope1, :scope2 ]
      [:all]
    end

    def list_attributes
      %i[
        id
        original_file
        story
        converting_state
      ]
    end

    def show_attributes
      %i[
        id
        original_file
        story
        converting_state
        state
        project_id
        created_at
        updated_at
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
