class Benchkiller::Tag < ApplicationRecord
  has_and_belongs_to_many :offers, class_name: 'Benchkiller::Offer'

  validates :title, uniqueness: true

  search_by :title
end
