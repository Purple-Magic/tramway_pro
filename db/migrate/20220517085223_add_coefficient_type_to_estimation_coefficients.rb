class AddCoefficientTypeToEstimationCoefficients < ActiveRecord::Migration[5.1]
  def change
    add_column :estimation_coefficients, :coefficient_type, :text, default: :price
  end
end
