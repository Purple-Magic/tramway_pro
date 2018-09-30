class AddProjectIdToTramwayConferencePeople < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_conference_people, :project_id, :integer
  end
end
