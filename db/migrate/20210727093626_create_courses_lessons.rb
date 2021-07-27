class CreateCoursesLessons < ActiveRecord::Migration[5.1]
  def change
    create_table :courses_lessons do |t|
      t.text :title
      t.integer :topic_id
      t.text :state
      t.integer :project_id

      t.timestamps
    end
  end
end
