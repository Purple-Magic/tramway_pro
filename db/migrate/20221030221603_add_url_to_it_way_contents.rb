class AddUrlToItWayContents < ActiveRecord::Migration[5.1]
  def change
    add_column :it_way_contents, :url, :text
  end
end
