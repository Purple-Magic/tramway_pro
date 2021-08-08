class AddProjectIdToPodcastMusics < ActiveRecord::Migration[5.1]
  def change
    add_column :podcast_musics, :project_id, :integer
  end
end
