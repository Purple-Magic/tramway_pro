class AddDescriptionToEstimationTasks < ActiveRecord::Migration[5.1]
  def change
    add_column :estimation_tasks, :description, :text
  end
end
