class AddStarIdToItWayPeople < ActiveRecord::Migration[5.1]
  def change
    add_column :it_way_people, :star_id, :integer
  end
end
