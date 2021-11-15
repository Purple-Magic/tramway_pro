class AddInstagramStoryToPodcastHighlights < ActiveRecord::Migration[5.1]
  def change
    add_column :podcast_highlights, :instagram_story, :text
  end
end
