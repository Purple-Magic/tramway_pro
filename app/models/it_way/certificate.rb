class ItWay::Certificate < Tramway::Core::ApplicationRecord
  belongs_to :event, class_name: 'Tramway::Event::Event'

  enumerize :certificate_type, in: [ :participant, :organizer ], default: :participant

  scope :participants, -> { where certificate_type: :participant }
end
