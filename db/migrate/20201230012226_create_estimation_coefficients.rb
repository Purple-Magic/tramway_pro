class CreateEstimationCoefficients < ActiveRecord::Migration[5.1]
  def change
    create_table :estimation_coefficients do |t|
      t.integer :estimation_project_id
      t.text :state
      t.float :scale
      t.integer :project_id
      t.text :title

      t.timestamps
    end
  end
end
