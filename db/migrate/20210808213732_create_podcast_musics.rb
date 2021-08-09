class CreatePodcastMusics < ActiveRecord::Migration[5.1]
  def change
    create_table :podcast_musics do |t|
      t.text :file
      t.text :music_type
      t.integer :podcast_id

      t.timestamps
    end
  end
end
