class AddPublicTitleToPodcastEpisodes < ActiveRecord::Migration[5.1]
  def change
    add_column :podcast_episodes, :public_title, :text
  end
end
