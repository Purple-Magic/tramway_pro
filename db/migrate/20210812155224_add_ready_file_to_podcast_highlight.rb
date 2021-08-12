class AddReadyFileToPodcastHighlight < ActiveRecord::Migration[5.1]
  def change
    add_column :podcast_highlights, :ready_file, :text
  end
end
