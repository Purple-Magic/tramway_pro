class ChangePodcastEpisodeTable < ActiveRecord::Migration[5.1]
  def change
    rename_table :episodes, :podcast_episodes
  end
end
