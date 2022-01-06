# frozen_string_literal: true

class RedMagicDecorator < ApplicationDecorator
  def title
    object.public_name
  end
end
