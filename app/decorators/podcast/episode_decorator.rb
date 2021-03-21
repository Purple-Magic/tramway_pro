# frozen_string_literal: true

class Podcast::EpisodeDecorator < Tramway::Core::ApplicationDecorator
  decorate_association :highlights

  class << self
    def show_associations
      [ :highlights ]
    end
  end

  def title
    "Выпуск №#{object.number}"
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
