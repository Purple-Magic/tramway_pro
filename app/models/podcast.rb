# frozen_string_literal: true

class Podcast < ApplicationRecord
  has_many :musics, class_name: 'Podcast::Music'
  has_many :episodes, -> { order(created_at: :desc) }, class_name: 'Podcast::Episode'
  has_many :stars, class_name: 'Podcast::Star'

  uploader :default_image, :photo, extensions: %i[png jpg jpeg]

  enumerize :podcast_type, in: %i[sample without_music different_music handmade]

  scope :podcast_scope, ->(_user_id) { all }

  def trailer_separator
    musics.where(music_type: :trailer_separator).first
  end
end
