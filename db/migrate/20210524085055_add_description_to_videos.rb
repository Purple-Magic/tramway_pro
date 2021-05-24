class AddDescriptionToVideos < ActiveRecord::Migration[5.1]
  def change
    add_column :videos, :description, :text
  end
end
