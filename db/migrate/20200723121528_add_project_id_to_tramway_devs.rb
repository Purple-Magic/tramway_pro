class AddProjectIdToTramwayDevs < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_devs, :project_id, :integer
  end
end
