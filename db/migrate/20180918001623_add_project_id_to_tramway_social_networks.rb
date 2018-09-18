class AddProjectIdToTramwaySocialNetworks < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_profiles_social_networks, :project_id, :integer
  end
end
