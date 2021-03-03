class ChangeTimeInPodcastHighlights < ActiveRecord::Migration[5.1]
  def change
    remove_column :podcast_highlights, :time
    add_column :podcast_highlights, :time, :text
  end
end
