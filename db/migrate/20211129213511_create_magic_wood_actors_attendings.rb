class CreateMagicWoodActorsAttendings < ActiveRecord::Migration[5.1]
  def change
    create_table :magic_wood_actors_attendings do |t|
      t.integer :estimation_project_id
      t.integer :actor_id
      t.text :state
      t.integer :project_id

      t.timestamps
    end
  end
end
