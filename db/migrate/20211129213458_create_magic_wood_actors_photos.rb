class CreateMagicWoodActorsPhotos < ActiveRecord::Migration[5.1]
  def change
    create_table :magic_wood_actors_photos do |t|
      t.integer :actor_id
      t.integer :project_id
      t.text :state
      t.text :file

      t.timestamps
    end
  end
end
