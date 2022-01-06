# frozen_string_literal: true

class Podcast::MusicDecorator < ApplicationDecorator
  def title
    "#{object.podcast.title} #{object.music_type}"
  end
end
