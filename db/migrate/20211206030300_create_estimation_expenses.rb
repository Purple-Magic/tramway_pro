class CreateEstimationExpenses < ActiveRecord::Migration[5.1]
  def change
    create_table :estimation_expenses do |t|
      t.integer :estimation_project_id
      t.integer :project_id
      t.text :state
      t.text :title
      t.float :count
      t.float :price
      t.text :description

      t.timestamps
    end
  end
end
