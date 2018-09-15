class AddPositionToTramwayEventParticipantFormFields < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_event_participant_form_fields, :position, :integer
  end
end
