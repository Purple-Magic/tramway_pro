# frozen_string_literal: true

class Podcast::EpisodeDecorator < Tramway::Core::ApplicationDecorator
  def title
    "Выпуск №#{object.number}"
  end
end
