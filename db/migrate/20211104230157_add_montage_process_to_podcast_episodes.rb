class AddMontageProcessToPodcastEpisodes < ActiveRecord::Migration[5.1]
  def change
    add_column :podcast_episodes, :montage_process, :text, default: :default
  end
end
