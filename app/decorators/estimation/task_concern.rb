# frozen_string_literal: true

module Estimation::TaskConcern
  def sum_with_coefficients
    price_with_coefficients * hours_with_coefficients * object.specialists_count
  end
end
