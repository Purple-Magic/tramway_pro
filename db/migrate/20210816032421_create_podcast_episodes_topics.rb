class CreatePodcastEpisodesTopics < ActiveRecord::Migration[5.1]
  def change
    create_table :podcast_episodes_topics do |t|
      t.integer :episode_id
      t.text :title
      t.text :link
      t.text :state
      t.integer :project_id
      t.text :discus_state
      t.text :timestamp

      t.timestamps
    end
  end
end
