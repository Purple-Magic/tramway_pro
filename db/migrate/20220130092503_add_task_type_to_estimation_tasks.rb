class AddTaskTypeToEstimationTasks < ActiveRecord::Migration[5.1]
  def change
    add_column :estimation_tasks, :task_type, :text, default: :single
  end
end
