# frozen_string_literal: true

class Listai::PageDecorator < Tramway::Core::ApplicationDecorator
  def title
    "Страница #{object.number}"
  end
end
