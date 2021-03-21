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
    url = ::Tramway::Export::Engine.routes.url_helpers.export_path(object.id, model: object.class, collection: :highlights)

    { show: [{ url: url, inner: -> { fa_icon 'file-excel' }, color: :success }] }
  end
end
