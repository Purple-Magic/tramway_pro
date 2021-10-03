class AddTeamToCourses < ActiveRecord::Migration[5.1]
  def change
    add_column :courses, :team, :text
  end
end
