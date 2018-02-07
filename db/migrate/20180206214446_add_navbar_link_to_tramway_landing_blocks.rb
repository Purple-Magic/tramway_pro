class AddNavbarLinkToTramwayLandingBlocks < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_landing_blocks, :navbar_link, :text, default: :not_exist
  end
end
