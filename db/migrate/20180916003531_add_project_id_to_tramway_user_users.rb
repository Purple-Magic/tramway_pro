class AddProjectIdToTramwayUserUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_user_users, :project_id, :integer
  end
end
