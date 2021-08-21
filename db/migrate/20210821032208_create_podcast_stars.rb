class CreatePodcastStars < ActiveRecord::Migration[5.1]
  def change
    create_table :podcast_stars do |t|
      t.text :nickname
      t.text :link
      t.integer :podcast_id

      t.timestamps
    end
  end
end
