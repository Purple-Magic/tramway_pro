class ItWay::Person < ApplicationRecord
  has_many :participations, class_name: 'ItWay::Participation'

  uploader :avatar, :photo, versions: [ :small, :medium ]
end
