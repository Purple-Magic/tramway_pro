# frozen_string_literal: true

class Podcast::EpisodeSerializer < Tramway::Api::V1::ApplicationSerializer
  attributes :podcast_id, :number
end
