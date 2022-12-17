class AddFooterToPodcastChannels < ActiveRecord::Migration[5.1]
  def change
    add_column :podcast_channels, :footer, :text
  end
end
