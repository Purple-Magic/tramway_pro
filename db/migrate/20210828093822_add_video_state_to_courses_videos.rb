class AddVideoStateToCoursesVideos < ActiveRecord::Migration[5.1]
  def change
    add_column :courses_videos, :video_state, :text
  end
end
