# frozen_string_literal: true

class Podcast::EpisodeDecorator < Tramway::Core::ApplicationDecorator
  decorate_association :highlights

  delegate_attributes :number

  class << self
    def show_associations
      [ :highlights ]
    end

    def show_attributes
      [ :title, :number, :file, :highlights_files ]
    end
  end

  def title
    "Выпуск №#{object.number}"
  end

  def file
    file_view object.file
  end

  def highlights_files
    parts = Dir["#{Rails.root}/public/podcasts/#{object.podcast.title.gsub(' ', '_')}/#{number}/*"]

    content_tag :table do
      parts.each do |part|
        concat(content_tag(:tr) do
          concat(content_tag(:td) do
            short_name = part.split('/').last

            link_to short_name, "/#{part.split('/')[-4..-1].join('/')}"
          end)
        end)
      end
    end
  end

  def additional_buttons
    export_url = ::Tramway::Export::Engine.routes.url_helpers.export_path(object.id, model: object.class, collection: :highlights)
    cut_highlights_url = Rails.application.routes.url_helpers.red_magic_api_v1_podcast_highlights_path(id: object.id)

    {
      show: [
        { url: export_url, inner: -> { fa_icon 'file-excel' }, color: :success },
        { url: cut_highlights_url, method: :post, inner: -> { fa_icon :highlighter }, color: :success },
      ]
    }
  end
end
