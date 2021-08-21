class AddColumnsToPodcastStars < ActiveRecord::Migration[5.1]
  def change
    add_column :podcast_stars, :project_id, :integer
    add_column :podcast_stars, :state, :text
  end
end
