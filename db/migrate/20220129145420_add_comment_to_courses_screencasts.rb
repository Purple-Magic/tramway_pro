class AddCommentToCoursesScreencasts < ActiveRecord::Migration[5.1]
  def change
    add_column :courses_screencasts, :comment, :text
  end
end
