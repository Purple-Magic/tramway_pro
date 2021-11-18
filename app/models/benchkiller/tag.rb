class Benchkiller::Tag < ApplicationRecord
  has_and_belongs_to_many :offers, class_name: 'Benchkiller::Offer'

  scope :benchkiller_scope, lambda { |_user| all }

  validates :title, uniqueness: true

  search_by :title
end
