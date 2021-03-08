class ChangePodcastHighlightsUuid < ActiveRecord::Migration[5.1]
  def change
    remove_column :podcast_highlights, :uuid
    add_column :podcast_highlights, :uuid, :uuid, default: -> { "uuid_generate_v4()" }
  end
end
