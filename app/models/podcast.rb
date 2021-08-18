# frozen_string_literal: true

class Podcast < ApplicationRecord
  has_many :musics, class_name: 'Podcast::Music'
  has_many :episodes, -> { order(created_at: :desc) }, class_name: 'Podcast::Episode'

  uploader :default_image, :photo, extensions: %i[png jpg jpeg]

  enumerize :podcast_type, in: %i[sample without_music different_music]

  scope :podcast_scope, -> (_user_id) { all }
end
