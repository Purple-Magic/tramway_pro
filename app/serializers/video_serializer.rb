# frozen_string_literal: true

class VideoSerializer < Tramway::Api::V1::ApplicationSerializer
  attributes :url, :preview, :title, :description
end
