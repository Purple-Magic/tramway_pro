# frozen_string_literal: true

module Estimation::CoefficientsConcern
  def price_with_coefficients
    result = object.price
    object.estimation_project.coefficients.for_price.order(:position).each do |coeff|
      result *= coeff.scale
    end
    result.round(2)
  end

  def hours_with_coefficients
    result = object.hours
    object.estimation_project.coefficients.for_hours.order(:position).each do |coeff|
      result *= coeff.scale
    end
    result.round(2)
  end
end
