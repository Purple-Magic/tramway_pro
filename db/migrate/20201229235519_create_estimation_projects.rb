class CreateEstimationProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :estimation_projects do |t|
      t.text :title
      t.text :state

      t.timestamps
    end
  end
end
