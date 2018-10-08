class AddMoreFieldsToTramwayEventParticipants < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_event_participants, :participation_state, :text, default: :requested
    add_column :tramway_event_participants, :comment, :text
  end
end
