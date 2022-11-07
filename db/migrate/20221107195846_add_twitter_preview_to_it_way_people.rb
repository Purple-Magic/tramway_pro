class AddTwitterPreviewToItWayPeople < ActiveRecord::Migration[5.1]
  def change
    add_column :it_way_people, :twitter_preview, :text
  end
end
