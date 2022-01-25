# frozen_string_literal: true

class VideoSerializer < ApplicationSerializer
  attributes :url, :preview, :title, :description
end
