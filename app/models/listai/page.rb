class Listai::Page < ApplicationRecord
  belongs_to :book, class_name: 'Listai::Book'
end
