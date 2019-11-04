class ItWay::Certificate < Tramway::Core::ApplicationRecord
  belongs_to :event, class_name: 'Tramway::Event::Event'
end
