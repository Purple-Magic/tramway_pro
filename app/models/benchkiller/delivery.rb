class Benchkiller::Delivery < ApplicationRecord
  validates :text, presence: true
end
