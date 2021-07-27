class CreateCoursesTopics < ActiveRecord::Migration[5.1]
  def change
    create_table :courses_topics do |t|
      t.text :title
      t.integer :course_id
      t.text :state
      t.integer :project_id

      t.timestamps
    end
  end
end
