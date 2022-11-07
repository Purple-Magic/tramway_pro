class AddPersonIdToItWayPerson < ActiveRecord::Migration[5.1]
  def change
    add_column :it_way_people, :event_person_id, :integer
  end
end
