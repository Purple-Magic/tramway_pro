class AddStateToCoursesScreencasts < ActiveRecord::Migration[5.1]
  def change
    add_column :courses_screencasts, :state, :text
  end
end
