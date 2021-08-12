class AddVideosToPodcastEpisodes < ActiveRecord::Migration[5.1]
  def change
    add_column :podcast_episodes, :full_video, :text
    add_column :podcast_episodes, :trailer_video, :text
  end
end
