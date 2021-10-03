class AddProjectIdToCoursesTasks < ActiveRecord::Migration[5.1]
  def change
    add_column :courses_tasks, :project_id, :integer
  end
end
