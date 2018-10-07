# NOTE must be removed until tramway-event 2.0

class RenameTramwayEventPeopleSectionsToTramwayEventPartakings < ActiveRecord::Migration[5.1]
  def change
    rename_table :tramway_event_people_sections, :tramway_event_partakings
  end
end
