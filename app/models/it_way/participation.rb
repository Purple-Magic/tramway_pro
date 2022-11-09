class ItWay::Participation < ApplicationRecord
  belongs_to :person, class_name: 'ItWay::Person'
  belongs_to :content, polymorphic: true

  enumerize :role, in: [ :speaker, :attender ]
  enumerize :content_type, in: ['ItWay::Content', 'Tramway::Event::Section'], default:  'ItWay::Content'
end
