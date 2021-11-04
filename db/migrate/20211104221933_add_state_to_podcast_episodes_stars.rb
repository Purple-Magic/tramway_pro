class AddStateToPodcastEpisodesStars < ActiveRecord::Migration[5.1]
  def change
    add_column :podcast_episodes_stars, :state, :text
  end
end
