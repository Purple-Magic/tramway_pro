class CreateContentStories < ActiveRecord::Migration[5.1]
  def change
    create_table :content_stories do |t|
      t.text :original_file
      t.text :story
      t.text :converting_state
      t.text :state
      t.integer :project_id

      t.timestamps
    end
  end
end
