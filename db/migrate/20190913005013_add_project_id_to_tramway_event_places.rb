class AddProjectIdToTramwayEventPlaces < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_event_places, :project_id, :integer
  end
end
