class CreateTramwayEventPeopleSections < ActiveRecord::Migration[5.1]
  def change
    create_table :tramway_event_people_sections do |t|
      t.integer :section_id
      t.integer :person_id

      t.timestamps
    end
  end
end
