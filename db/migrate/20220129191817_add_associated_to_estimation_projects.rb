class AddAssociatedToEstimationProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :estimation_projects, :associated_id, :integer
    add_column :estimation_projects, :associated_type, :text
  end
end
