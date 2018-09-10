class AddProjectIdToTramwayEventParticipants < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_event_participants, :project_id, :integer
  end
end
