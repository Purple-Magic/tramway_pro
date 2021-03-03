# frozen_string_literal: true

class Podcast::HighlightSerializer < Tramway::Api::V1::ApplicationSerializer
  attributes :podcast_id, :time
end
