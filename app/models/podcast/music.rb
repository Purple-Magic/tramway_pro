class Podcast::Music < ApplicationRecord
  belongs_to :podcast, class_name: 'Podcast'

  enumerize :music_type, in: [ :begin, :sample, :finish ]
end
