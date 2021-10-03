class AddStateToCoursesTasks < ActiveRecord::Migration[5.1]
  def change
    add_column :courses_tasks, :state, :text
  end
end
