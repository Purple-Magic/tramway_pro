class AddOptionsToCourses < ActiveRecord::Migration[5.1]
  def change
    add_column :courses, :options, :jsonb
  end
end
