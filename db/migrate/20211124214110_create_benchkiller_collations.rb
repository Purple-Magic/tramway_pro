class CreateBenchkillerCollations < ActiveRecord::Migration[5.1]
  def change
    create_table :benchkiller_collations do |t|
      t.integer :project_id
      t.text :state
      t.text :main
      t.text :words, array: true

      t.timestamps
    end
  end
end
