class ItWay::Person < ApplicationRecord
  belongs_to :event_person, class_name: 'Tramway::Event::Person', optional: true
  has_many :participations, class_name: 'ItWay::Participation'
  has_many :points, class_name: 'ItWay::People::Point'

  uploader :avatar, :photo, versions: [ :small, :medium ]
  uploader :twitter_preview, :photo
end
