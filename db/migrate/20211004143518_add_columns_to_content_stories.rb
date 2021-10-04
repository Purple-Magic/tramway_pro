class AddColumnsToContentStories < ActiveRecord::Migration[5.1]
  def change
    add_column :content_stories, :begin_time, :text
    add_column :content_stories, :end_time, :text
  end
end
