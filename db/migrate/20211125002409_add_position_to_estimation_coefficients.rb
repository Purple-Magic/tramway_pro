class AddPositionToEstimationCoefficients < ActiveRecord::Migration[5.1]
  def change
    add_column :estimation_coefficients, :position, :integer
  end
end
