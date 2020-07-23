class AddMainImageToTramwayDevs < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_devs, :main_image, :text
  end
end
