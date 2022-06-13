# frozen_string_literal: true

module Estimation::ExpenseConcern
  def sum_with_coefficients
    (price_with_coefficients * object.count).round 2
  end
end
