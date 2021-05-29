class AddProjectIdToTramwayNewsNews < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_news_news, :project_id, :integer
  end
end
