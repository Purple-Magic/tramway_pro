class AddProjectIdToTramwayLandingBlocks < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_landing_blocks, :project_id, :integer
  end
end
