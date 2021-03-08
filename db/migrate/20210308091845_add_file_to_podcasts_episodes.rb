class AddFileToPodcastsEpisodes < ActiveRecord::Migration[5.1]
  def change
    add_column :podcast_episodes, :file, :text
  end
end
