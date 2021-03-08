class RenameColumnInPodcastHighlights < ActiveRecord::Migration[5.1]
  def change
    rename_column :podcast_highlights, :podcast_id, :episode_id
  end
end
