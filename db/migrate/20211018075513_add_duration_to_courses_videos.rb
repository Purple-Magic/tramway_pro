class AddDurationToCoursesVideos < ActiveRecord::Migration[5.1]
  def change
    add_column :courses_videos, :duration, :text
  end
end
