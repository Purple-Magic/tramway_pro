class CreateTramwayConferencePeopleEventEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :tramway_conference_people_event_events do |t|
      t.integer :event_id
      t.integer :person_id

      t.timestamps
    end
  end
end
