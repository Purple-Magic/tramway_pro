class AddDescriptionToEstimationProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :estimation_projects, :description, :text
  end
end
