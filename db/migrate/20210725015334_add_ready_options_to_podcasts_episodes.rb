class AddReadyOptionsToPodcastsEpisodes < ActiveRecord::Migration[5.1]
  def change
    add_column :podcast_episodes, :cover, :text
    add_column :podcast_episodes, :ready_file, :text
  end
end
