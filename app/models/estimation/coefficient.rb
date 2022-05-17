# frozen_string_literal: true

class Estimation::Coefficient < ApplicationRecord
  belongs_to :estimation_project, class_name: 'Estimation::Project'

  enumerize :coefficient_type, in: [ :price, :hours ], default: :price

  scope :for_price, -> { where coefficient_type: :price }
  scope :for_hours, -> { where coefficient_type: :hours }
end
