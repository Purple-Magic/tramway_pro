class AddProjectIdToBots < ActiveRecord::Migration[5.1]
  def change
    add_column :bots, :project_id, :integer
  end
end
