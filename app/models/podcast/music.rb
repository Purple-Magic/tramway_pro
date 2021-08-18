# frozen_string_literal: true

class Podcast::Music < ApplicationRecord
  belongs_to :podcast, class_name: 'Podcast'

  scope :podcast_scope, ->(_user_id) { all }

  uploader :file, :file

  enumerize :music_type, in: %i[begin sample finish trailer_separator]
end
