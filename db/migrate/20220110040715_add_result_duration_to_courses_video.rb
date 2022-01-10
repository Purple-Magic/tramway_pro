class AddResultDurationToCoursesVideo < ActiveRecord::Migration[5.1]
  def change
    add_column :courses_videos, :result_duration, :text
  end
end
