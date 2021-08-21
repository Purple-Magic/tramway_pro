class CreatePodcastEpisodesPodcastStars < ActiveRecord::Migration[5.1]
  def change
    create_table :podcast_episodes_stars do |t|
      t.integer :episode_id
      t.integer :star_id
    end
  end
end
