class AddOptionsToPodcastChannels < ActiveRecord::Migration[5.1]
  def change
    add_column :podcast_channels, :options, :jsonb
  end
end
