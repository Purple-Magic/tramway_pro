class CreateTramwayEventParticipantFormFields < ActiveRecord::Migration[5.1]
  def change
    create_table :tramway_event_participant_form_fields do |t|
      t.text :title
      t.text :description
      t.text :field_type, default: :text
      t.integer :event_id
      t.text :state, default: :active

      t.timestamps
    end
  end
end
