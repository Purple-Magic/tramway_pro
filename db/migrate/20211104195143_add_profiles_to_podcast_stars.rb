class AddProfilesToPodcastStars < ActiveRecord::Migration[5.1]
  def change
    add_column :podcast_stars, :profiles, :jsonb
  end
end
