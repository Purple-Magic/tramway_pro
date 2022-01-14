class AddUrlToCoursesVideos < ActiveRecord::Migration[5.1]
  def change
    add_column :courses_videos, :url, :text
  end
end
