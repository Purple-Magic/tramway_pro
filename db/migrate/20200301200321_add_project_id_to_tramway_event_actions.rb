class AddProjectIdToTramwayEventActions < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_event_actions, :project_id, :integer
  end
end
