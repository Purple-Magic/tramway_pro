class AddFileToCoursesComments < ActiveRecord::Migration[5.1]
  def change
    add_column :courses_comments, :file, :text
  end
end
