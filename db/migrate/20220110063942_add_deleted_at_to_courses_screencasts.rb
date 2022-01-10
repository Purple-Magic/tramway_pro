class AddDeletedAtToCoursesScreencasts < ActiveRecord::Migration[5.1]
  def change
    add_column :courses_screencasts, :deleted_at, :datetime
  end
end
