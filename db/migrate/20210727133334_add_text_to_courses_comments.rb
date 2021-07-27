class AddTextToCoursesComments < ActiveRecord::Migration[5.1]
  def change
    add_column :courses_comments, :text, :text
  end
end
