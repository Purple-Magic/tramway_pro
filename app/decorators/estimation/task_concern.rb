module Estimation::TaskConcern
  def price_with_coefficients
    result = object.price
    object.estimation_project.coefficients.each do |coeff|
      result *= coeff.scale
    end
    result.round
  end

  def sum_with_coefficients
    result = object.sum
    object.estimation_project.coefficients.each do |coeff|
      result *= coeff.scale
    end
    result.round
  end
end
