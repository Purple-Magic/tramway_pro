class CreatePodcastEpisodesParts < ActiveRecord::Migration[5.1]
  def change
    create_table :podcast_episodes_parts do |t|
      t.integer :episode_id
      t.integer :project_id
      t.datetime :deleted_at
      t.text :begin_time
      t.text :end_time
      t.text :state
      t.text :preview

      t.timestamps
    end
  end
end
