class AddDefaultPriceToEstimationProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :estimation_projects, :default_price, :integer
  end
end
