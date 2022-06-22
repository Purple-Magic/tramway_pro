class AddStoryCoverToPodcastEpisodes < ActiveRecord::Migration[5.1]
  def change
    add_column :podcast_episodes, :story_cover, :text
    add_column :podcast_episodes, :story_trailer_video, :text
  end
end
