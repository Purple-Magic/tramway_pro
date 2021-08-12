class Podcast::Music < ApplicationRecord
  belongs_to :podcast, class_name: 'Podcast'

  uploader :file, :file

  enumerize :music_type, in: [ :begin, :sample, :finish, :trailer_separator ]
end
