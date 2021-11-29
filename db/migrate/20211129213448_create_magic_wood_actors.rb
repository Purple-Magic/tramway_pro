class CreateMagicWoodActors < ActiveRecord::Migration[5.1]
  def change
    create_table :magic_wood_actors do |t|
      t.text :first_name
      t.text :last_name
      t.text :state
      t.integer :project_id

      t.timestamps
    end
  end
end
