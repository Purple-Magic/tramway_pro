class AddPhraseToCoursesComments < ActiveRecord::Migration[5.1]
  def change
    add_column :courses_comments, :phrase, :text
  end
end
