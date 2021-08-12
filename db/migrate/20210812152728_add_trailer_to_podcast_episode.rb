class AddTrailerToPodcastEpisode < ActiveRecord::Migration[5.1]
  def change
    add_column :podcast_episodes, :trailer, :text
  end
end
