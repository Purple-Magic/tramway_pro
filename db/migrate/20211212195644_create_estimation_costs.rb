class CreateEstimationCosts < ActiveRecord::Migration[5.1]
  def change
    create_table :estimation_costs do |t|
      t.integer :associated_id
      t.text :associated_type
      t.float :price
      t.text :state
      t.integer :project_id

      t.timestamps
    end
  end
end
