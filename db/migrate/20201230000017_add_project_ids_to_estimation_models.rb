class AddProjectIdsToEstimationModels < ActiveRecord::Migration[5.1]
  def change
    add_column :estimation_projects, :project_id, :integer
    add_column :estimation_tasks, :project_id, :integer
  end
end
