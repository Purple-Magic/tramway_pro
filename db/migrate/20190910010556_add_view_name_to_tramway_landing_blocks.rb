class AddViewNameToTramwayLandingBlocks < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_landing_blocks, :view_name, :text
  end
end
