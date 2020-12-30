class ChangeEstimationTasksColumn < ActiveRecord::Migration[5.1]
  def change
    remove_column :estimation_tasks, :hours
    add_column :estimation_tasks, :hours, :float

    remove_column :estimation_tasks, :price
    add_column :estimation_tasks, :price, :float
  end
end
