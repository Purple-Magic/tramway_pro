class CreateCoursesVideos < ActiveRecord::Migration[5.1]
  def change
    create_table :courses_videos do |t|
      t.integer :lesson_id
      t.text :text
      t.text :state
      t.integer :project_id

      t.timestamps
    end
  end
end
