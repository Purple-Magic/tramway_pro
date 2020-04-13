class AddFaviconToTramwayDevs < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_devs, :favicon, :text
  end
end
