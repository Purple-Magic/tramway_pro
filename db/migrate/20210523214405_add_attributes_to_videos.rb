class AddAttributesToVideos < ActiveRecord::Migration[5.1]
  def change
    add_column :videos, :title, :text
    add_column :videos, :preview, :text
  end
end
