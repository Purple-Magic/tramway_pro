# frozen_string_literal: true

class Podcast::HighlightDecorator < Tramway::Core::ApplicationDecorator
  def title
    object.time
  end
end
