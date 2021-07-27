class CreateCourses < ActiveRecord::Migration[5.1]
  def change
    create_table :courses do |t|
      t.text :title
      t.text :state
      t.integer :project_id

      t.timestamps
    end
  end
end
