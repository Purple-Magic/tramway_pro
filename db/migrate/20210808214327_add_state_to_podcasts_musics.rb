class AddStateToPodcastsMusics < ActiveRecord::Migration[5.1]
  def change
    add_column :podcast_musics, :state, :text
  end
end
