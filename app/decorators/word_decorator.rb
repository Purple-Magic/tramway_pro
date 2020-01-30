# frozen_string_literal: true

class WordDecorator < Tramway::Core::ApplicationDecorator
  def title
    object.main
  end
end
