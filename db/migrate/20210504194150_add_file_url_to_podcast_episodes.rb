class AddFileUrlToPodcastEpisodes < ActiveRecord::Migration[5.1]
  def change
    add_column :podcast_episodes, :file_url, :text
  end
end
