# NOTE must be removed until tramway-event 2.0

class RebuildAssociationBetweenParticipantAndPartakingsToPolymorphic < ActiveRecord::Migration[5.1]
  def change
    rename_column :tramway_event_partakings, :section_id, :part_id
    add_column :tramway_event_partakings, :part_type, :text, default: 'Tramway::Event::Section'
  end
end
