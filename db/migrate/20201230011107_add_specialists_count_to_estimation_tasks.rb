class AddSpecialistsCountToEstimationTasks < ActiveRecord::Migration[5.1]
  def change
    add_column :estimation_tasks, :specialists_count, :integer, default: 1
  end
end
