class ItWay::Content < ApplicationRecord
  belongs_to :associated, polymorphic: true
  has_many :participations, class_name: 'ItWay::Participation', foreign_key: :content_id

  enumerize :associated_type, in: [Tramway::Event::Event]
end
