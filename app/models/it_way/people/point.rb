class ItWay::People::Point < ApplicationRecord
  belongs_to :person, class_name: 'ItWay::Person'
end
