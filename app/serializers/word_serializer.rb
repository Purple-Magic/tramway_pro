class WordSerializer < Tramway::Api::V1::ApplicationSerializer
  attributes :main, :synonims, :description
end
