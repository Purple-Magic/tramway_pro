# frozen_string_literal: true

class Podcast::MusicDecorator < Tramway::Core::ApplicationDecorator
  def title
    "#{object.podcast.title} #{object.music_type}"
  end
end
