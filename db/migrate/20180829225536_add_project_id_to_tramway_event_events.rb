class AddProjectIdToTramwayEventEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_event_events, :project_id, :integer
  end
end
