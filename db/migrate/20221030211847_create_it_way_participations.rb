class CreateItWayParticipations < ActiveRecord::Migration[5.1]
  def change
    create_table :it_way_participations do |t|
      t.integer :person_id
      t.integer :content_id
      t.text :state
      t.datetime :deleted_at
      t.integer :project_id
      t.text :role

      t.timestamps
    end
  end
end
