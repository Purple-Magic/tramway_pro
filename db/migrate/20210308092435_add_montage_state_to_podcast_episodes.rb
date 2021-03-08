class AddMontageStateToPodcastEpisodes < ActiveRecord::Migration[5.1]
  def change
    add_column :podcast_episodes, :montage_state, :text
  end
end
