# frozen_string_literal: true

class Listai::PageDecorator < ApplicationDecorator
  def title
    "Страница #{object.number}"
  end
end
