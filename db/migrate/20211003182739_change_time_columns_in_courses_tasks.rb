class ChangeTimeColumnsInCoursesTasks < ActiveRecord::Migration[5.1]
  def change
    remove_column :courses_tasks, :max_time
    remove_column :courses_tasks, :min_time
    add_column :courses_tasks, :max_time, :text
    add_column :courses_tasks, :min_time, :text
  end
end
