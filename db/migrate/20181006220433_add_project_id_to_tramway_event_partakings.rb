class AddProjectIdToTramwayEventPartakings < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_event_partakings, :project_id, :integer
  end
end
