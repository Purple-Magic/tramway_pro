# frozen_string_literal: true

class Podcast < ApplicationRecord
  has_many :episodes, -> { order(created_at: :desc) }, class_name: 'Podcast::Episode'

  uploader :default_image, :photo, extensions: [ :png, :jpg, :jpeg ]
end
