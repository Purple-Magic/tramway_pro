class CreateCoursesScreencasts < ActiveRecord::Migration[5.1]
  def change
    create_table :courses_screencasts do |t|
      t.integer :project_id
      t.integer :video_id
      t.text :scenario

      t.timestamps
    end
  end
end
