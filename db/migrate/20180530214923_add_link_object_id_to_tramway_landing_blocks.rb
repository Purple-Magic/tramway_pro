class AddLinkObjectIdToTramwayLandingBlocks < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_landing_blocks, :link_object_id, :integer
  end
end
