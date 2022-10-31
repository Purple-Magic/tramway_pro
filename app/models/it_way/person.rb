class ItWay::Person < ApplicationRecord
  belongs_to :star, class_name: 'Podcast::Star'
  has_many :participations, class_name: 'ItWay::Participation'

  uploader :avatar, :photo, versions: [ :small, :medium ]
end
