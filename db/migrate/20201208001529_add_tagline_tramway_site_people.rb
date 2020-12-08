class AddTaglineTramwaySitePeople < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_site_people, :tagline, :text
  end
end
