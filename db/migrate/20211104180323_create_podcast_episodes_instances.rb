class CreatePodcastEpisodesInstances < ActiveRecord::Migration[5.1]
  def change
    create_table :podcast_episodes_instances do |t|
      t.integer :episode_id
      t.text :state
      t.integer :project_id
      t.text :service
      t.text :link

      t.timestamps
    end
  end
end
