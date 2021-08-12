class AddFileToPodcastHighlights < ActiveRecord::Migration[5.1]
  def change
    add_column :podcast_highlights, :file, :text
  end
end
