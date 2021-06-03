# frozen_string_literal: true

class Podcast::EpisodeDecorator < Tramway::Core::ApplicationDecorator
  decorate_association :highlights

  delegate_attributes :number, :file_url

  class << self
    def show_associations
      [:highlights]
    end

    def show_attributes
      %i[title number file image mp3 description highlights_files]
    end
  end

  def title
    "Выпуск №#{object.number}"
  end

  def image
    image_tag(object.image, style: 'height: 200px') if object.image.present?
  end

  def mp3
    file_url = object.attributes['file_url']
    link_to file_url, file_url if file_url.present?
  end

  def description
    raw object.description
  end

  def file
    file_view object.file
  end

  def highlights_files
    parts = Dir["#{object.parts_directory_name}/*.mp3"]

    content_tag :table do
      parts.each do |part|
        concat(content_tag(:tr) do
          concat(content_tag(:td) do
            short_name = part.split('/').last
            link_to short_name, "/#{part.split('/')[-4..].join('/')}"
          end)
        end)
      end
    end
  end

  def additional_buttons
    export_url = ::Tramway::Export::Engine.routes.url_helpers.export_path(
      object.id,
      model: object.class,
      collection: :highlights
    )

    cut_highlights_url = Rails.application.routes.url_helpers.red_magic_api_v1_podcast_highlights_path(id: object.id)
    #download_all_parts = Rails.application.routes.url_helpers.red_magic_api_v1_podcast_episode_

    {
      show: [
        { url: export_url, inner: -> { fa_icon 'file-excel' }, color: :success },
        { url: cut_highlights_url, method: :post, inner: -> { fa_icon :highlighter }, color: :success }
        #{ url: cut_highlights_url, method: :post, inner: -> { fa_icon :highlighter }, color: :success }
      ]
    }
  end

  def montage_button_color(event); end
end
