class AddProjectIdToTramwayConferenceUnities < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_conference_unities, :project_id, :integer
  end
end
