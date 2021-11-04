class AddNamesToPodcastStars < ActiveRecord::Migration[5.1]
  def change
    add_column :podcast_stars, :first_name, :text
    add_column :podcast_stars, :last_name, :text
  end
end
