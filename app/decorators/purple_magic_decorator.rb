# frozen_string_literal: true

class PurpleMagicDecorator < ApplicationDecorator
  def title
    object.public_name
  end
end
