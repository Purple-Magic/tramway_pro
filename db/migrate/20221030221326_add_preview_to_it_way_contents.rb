class AddPreviewToItWayContents < ActiveRecord::Migration[5.1]
  def change
    add_column :it_way_contents, :preview, :text
  end
end
