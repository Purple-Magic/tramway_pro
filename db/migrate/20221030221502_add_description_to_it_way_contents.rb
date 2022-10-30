class AddDescriptionToItWayContents < ActiveRecord::Migration[5.1]
  def change
    add_column :it_way_contents, :description, :text
  end
end
