class AddReleaseDateToCoursesVideos < ActiveRecord::Migration[5.1]
  def change
    add_column :courses_videos, :release_date, :datetime
  end
end
