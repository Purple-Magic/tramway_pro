# frozen_string_literal: true

class EpisodeBlockDecorator < ApplicationDecorator
  delegate_attributes :title

  def anchor
    "episode_#{object.number}"
  end

  def background
    object.image
  end
end
