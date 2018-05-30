class AddLinkObjectTypeToTramwayLandingBlocks < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_landing_blocks, :link_object_type, :text
  end
end
