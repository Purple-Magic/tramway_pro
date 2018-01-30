class CreateTramwayLandingBlocks < ActiveRecord::Migration[5.1]
  def change
    create_table :tramway_landing_blocks do |t|
      t.text :title
      t.text :background
      t.text :block_type
      t.integer :position
      t.text :state, default: :active
      t.text :view_state, default: :hidden

      t.timestamps
    end
  end
end
