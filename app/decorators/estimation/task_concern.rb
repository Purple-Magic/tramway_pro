# frozen_string_literal: true

module Estimation::TaskConcern
  def price_with_coefficients
    result = object.price
    object.estimation_project.coefficients.each do |coeff|
      result *= coeff.scale
    end
    result.round(2)
  end

  def sum_with_coefficients
    price_with_coefficients * object.hours * object.specialists_count
  end
end
