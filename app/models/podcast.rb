# frozen_string_literal: true

class Podcast < ApplicationRecord
  has_many :musics, class_name: 'Podcast::Music', dependent: :destroy
  has_many :episodes, -> { order(created_at: :desc) }, class_name: 'Podcast::Episode', dependent: :destroy
  has_many :stars, class_name: 'Podcast::Star', dependent: :destroy
  has_many :time_logs, class_name: 'TimeLog', through: :episodes, dependent: :destroy
  has_many :stats, class_name: 'Podcast::Stat', dependent: :destroy
  has_many :channels, class_name: 'Podcast::Channel', dependent: :destroy

  uploader :default_image, :photo, extensions: %i[png jpg jpeg]

  enumerize :podcast_type, in: %i[sample without_music different_music handmade]

  scope :podcast_scope, ->(_user_id) { all }

  def trailer_separator
    musics.where(music_type: :trailer_separator).first
  end
end
