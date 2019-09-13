class CreateTramwayEventEventsPlaces < ActiveRecord::Migration[5.1]
  def change
    create_table :tramway_event_events_places do |t|
      t.integer :event_id
      t.integer :place_id

      t.timestamps
    end
  end
end
