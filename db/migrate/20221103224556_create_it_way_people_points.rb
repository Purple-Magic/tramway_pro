class CreateItWayPeoplePoints < ActiveRecord::Migration[5.1]
  def change
    create_table :it_way_people_points do |t|
      t.integer :person_id
      t.integer :count
      t.text :comment
      t.datetime :deleted_at
      t.text :state
      t.integer :project_id

      t.timestamps
    end
  end
end
