class AddProjectIdToTramwayLandingTools < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_landing_tools, :project_id, :integer
  end
end
