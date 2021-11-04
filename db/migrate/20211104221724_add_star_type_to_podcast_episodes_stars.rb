class AddStarTypeToPodcastEpisodesStars < ActiveRecord::Migration[5.1]
  def change
    add_column :podcast_episodes_stars, :star_type, :text, default: :main
  end
end
