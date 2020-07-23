class AddTitleToTramwayDevs < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_devs, :title, :text
  end
end
