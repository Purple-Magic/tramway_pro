class AddPremontageFileToPodcastEpisodes < ActiveRecord::Migration[5.1]
  def change
    add_column :podcast_episodes, :premontage_file, :text
  end
end
