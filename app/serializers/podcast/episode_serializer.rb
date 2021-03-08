# frozen_string_literal: true

class Podcast::EpisodeSerializer < Tramway::Api::V1::ApplicationSerializer
  attributes :podcast_id, :number

  has_many :highlights, serializer: Podcast::HighlightSerializer
end
