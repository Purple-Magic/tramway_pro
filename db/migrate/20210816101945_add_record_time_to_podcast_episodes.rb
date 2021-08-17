class AddRecordTimeToPodcastEpisodes < ActiveRecord::Migration[5.1]
  def change
    add_column :podcast_episodes, :record_time, :datetime
  end
end
