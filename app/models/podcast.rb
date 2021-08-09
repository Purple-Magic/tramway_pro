# frozen_string_literal: true

class Podcast < ApplicationRecord
  has_many :musics, class_name: 'Podcast::Music'
  has_many :episodes, -> { order(created_at: :desc) }, class_name: 'Podcast::Episode'

  uploader :default_image, :photo, extensions: %i[png jpg jpeg]

  enumerize :podcast_type, in: [ :sample, :without_music, :different_music ]
end
