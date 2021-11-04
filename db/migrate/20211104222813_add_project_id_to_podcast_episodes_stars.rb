class AddProjectIdToPodcastEpisodesStars < ActiveRecord::Migration[5.1]
  def change
    add_column :podcast_episodes_stars, :project_id, :integer
  end
end
