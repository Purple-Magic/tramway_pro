module Estimation::TaskConcern
  def sum_with_coefficients
    price_with_coefficients * object.hours * object.specialists_count
  end
end
