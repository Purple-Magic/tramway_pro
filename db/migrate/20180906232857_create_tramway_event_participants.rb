class CreateTramwayEventParticipants < ActiveRecord::Migration[5.1]
  def change
    create_table :tramway_event_participants do |t|
      t.integer :event_id
      t.jsonb :values
      t.text :state, default: :active

      t.timestamps
    end
  end
end
