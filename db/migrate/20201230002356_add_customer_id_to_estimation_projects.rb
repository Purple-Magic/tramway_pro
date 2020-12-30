class AddCustomerIdToEstimationProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :estimation_projects, :customer_id, :integer
  end
end
