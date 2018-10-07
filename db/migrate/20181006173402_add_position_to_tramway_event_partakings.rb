class AddPositionToTramwayEventPartakings < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_event_partakings, :position, :text
  end
end
