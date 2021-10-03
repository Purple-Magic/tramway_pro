class AddPreparednessStateToCoursesTasks < ActiveRecord::Migration[5.1]
  def change
    add_column :courses_tasks, :preparedness, :text
  end
end
