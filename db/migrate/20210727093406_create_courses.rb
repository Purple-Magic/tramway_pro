class CreateCourses < ActiveRecord::Migration[5.1]
  def change
    create_table :courses do |t|
      t.text :title
      t.text :state

      t.timestamps
    end
  end
end
