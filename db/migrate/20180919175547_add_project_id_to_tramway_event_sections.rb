class AddProjectIdToTramwayEventSections < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_event_sections, :project_id, :integer
  end
end
