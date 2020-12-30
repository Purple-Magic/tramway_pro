class AddStateToEstimationTasks < ActiveRecord::Migration[5.1]
  def change
    add_column :estimation_tasks, :state, :text
  end
end
