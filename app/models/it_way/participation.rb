class ItWay::Participation < ApplicationRecord
  belongs_to :person, class_name: 'ItWay::Person'
  belongs_to :content, class_name: 'ItWay::Content'

  enumerize :role, in: [ :speaker ]
end
