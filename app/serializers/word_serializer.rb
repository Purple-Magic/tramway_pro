# frozen_string_literal: true

class WordSerializer < Tramway::Api::V1::ApplicationSerializer
  attributes :main, :synonims, :description
end
