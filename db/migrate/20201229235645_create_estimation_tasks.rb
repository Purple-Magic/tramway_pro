class CreateEstimationTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :estimation_tasks do |t|
      t.text :title
      t.integer :hours
      t.integer :price
      t.integer :estimation_project_id

      t.timestamps
    end
  end
end
