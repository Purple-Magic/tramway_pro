class AddStateToVideos < ActiveRecord::Migration[5.1]
  def change
    add_column :videos, :state, :text
  end
end
