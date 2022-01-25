# frozen_string_literal: true

class Podcast::EpisodeSerializer < ApplicationSerializer
  has_many :highlights, serializer: Podcast::HighlightSerializer
  belongs_to :podcast, serializer: PodcastSerializer

  attributes :podcast_id, :number, :title, :number, :season, :description, :published_at, :image, :explicit, :file_url,
    :duration

  def title
    object.title&.split(' Episode')&.first
  end

  def published_at
    object.published_at&.strftime('%d.%m.%Y')
  end

  def image
    object.image.present? ? object.image : "http://#{ENV['PROJECT_URL']}#{object.podcast.default_image.url}"
  end

  def file_url
    object.attributes['file_url']
  end

  def description
    # object.raw_description
  end
end
