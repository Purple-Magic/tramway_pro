class AddRenderDataToPodcastEpisodes < ActiveRecord::Migration[5.1]
  def change
    add_column :podcast_episodes, :render_data, :jsonb
  end
end
