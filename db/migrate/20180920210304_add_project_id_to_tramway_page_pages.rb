class AddProjectIdToTramwayPagePages < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_page_pages, :project_id, :integer
  end
end
