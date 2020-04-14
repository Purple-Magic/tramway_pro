class AddProjectIdToListaiPages < ActiveRecord::Migration[5.1]
  def change
    add_column :listai_pages, :project_id, :integer
  end
end
