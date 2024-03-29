# frozen_string_literal: true

class Listai::BookDecorator < ApplicationDecorator
  class << self
    def show_associations
      [:pages]
    end
  end

  delegate :title, to: :object

  decorate_association :pages
end
