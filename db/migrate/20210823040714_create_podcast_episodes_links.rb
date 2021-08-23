class CreatePodcastEpisodesLinks < ActiveRecord::Migration[5.1]
  def change
    create_table :podcast_episodes_links do |t|
      t.integer :episode_id
      t.text :title
      t.text :link
      t.integer :project_id
      t.text :state

      t.timestamps
    end
  end
end
