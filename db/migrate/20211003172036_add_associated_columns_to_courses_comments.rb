class AddAssociatedColumnsToCoursesComments < ActiveRecord::Migration[5.1]
  def change
    add_column :courses_comments, :associated_id, :integer
    add_column :courses_comments, :associated_type, :text
  end
end
