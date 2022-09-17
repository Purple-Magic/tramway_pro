class AddPublishDateToPodcastEpisodes < ActiveRecord::Migration[5.1]
  def change
    add_column :podcast_episodes, :publish_date, :datetime
  end
end
