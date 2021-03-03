class AddUuidToPodcastHighlights < ActiveRecord::Migration[5.1]
  def change
    add_column :podcast_highlights, :uuid, :uuid
  end
end
