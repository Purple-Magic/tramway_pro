# frozen_string_literal: true

class Podcast::EpisodeSerializer < Tramway::Api::V1::ApplicationSerializer
  attributes :podcast_id, :number, :title, :number, :season, :description, :published_at, :image, :explicit, :file_url,
    :duration

  def published_at
    object.published_at.strftime("%d.%m.%Y")
  end

  has_many :highlights, serializer: Podcast::HighlightSerializer
  belongs_to :podcast, serializer: PodcastSerializer
end
