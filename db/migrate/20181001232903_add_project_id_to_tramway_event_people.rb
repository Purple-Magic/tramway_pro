class AddProjectIdToTramwayEventPeople < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_event_people, :project_id, :integer
  end
end
