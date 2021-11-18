class Benchkiller::Delivery < ApplicationRecord
  validates :text, presence: true

  scope :benchkiller_scope, lambda { |_user| all }
end
