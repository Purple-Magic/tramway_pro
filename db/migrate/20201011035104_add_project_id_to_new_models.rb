class AddProjectIdToNewModels < ActiveRecord::Migration[5.1]
  def change
    add_column :podcasts, :project_id, :integer
    add_column :episodes, :project_id, :integer
  end
end
