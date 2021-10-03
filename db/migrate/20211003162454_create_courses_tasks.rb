class CreateCoursesTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :courses_tasks do |t|
      t.integer :lesson_id
      t.integer :position
      t.text :text
      t.integer :max_time
      t.integer :min_time

      t.timestamps
    end
  end
end
