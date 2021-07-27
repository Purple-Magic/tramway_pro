class AddPositionsToCoursesModels < ActiveRecord::Migration[5.1]
  def change
    add_column :courses_topics, :position, :integer
    add_column :courses_lessons, :position, :integer
    add_column :courses_videos, :position, :integer
  end
end
