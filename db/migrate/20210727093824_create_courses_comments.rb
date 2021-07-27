class CreateCoursesComments < ActiveRecord::Migration[5.1]
  def change
    create_table :courses_comments do |t|
      t.integer :video_id
      t.text :begin_time
      t.text :end_time
      t.text :state
      t.integer :project_id

      t.timestamps
    end
  end
end
