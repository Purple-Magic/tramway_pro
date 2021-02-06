class AddProjectStateToEstimationProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :estimation_projects, :project_state, :text, default: :estimation_in_progress
  end
end
