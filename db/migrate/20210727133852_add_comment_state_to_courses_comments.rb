class AddCommentStateToCoursesComments < ActiveRecord::Migration[5.1]
  def change
    add_column :courses_comments, :comment_state, :text
  end
end
