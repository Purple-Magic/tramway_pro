# frozen_string_literal: true

class AddPageIdToTramwayLandingBlocks < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_landing_blocks, :page_id, :integer
  end
end
