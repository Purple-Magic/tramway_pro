class CreateItWayPeople < ActiveRecord::Migration[5.1]
  def change
    create_table :it_way_people do |t|
      t.text :first_name
      t.text :last_name
      t.text :avatar
      t.text :state
      t.datetime :deleted_at
      t.integer :project_id

      t.timestamps
    end
  end
end
