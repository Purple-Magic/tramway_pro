class CreatePodcastChannels < ActiveRecord::Migration[5.1]
  def change
    create_table :podcast_channels do |t|
      t.integer :podcast_id
      t.text :service
      t.text :title
      t.text :state
      t.datetime :deleted_at
      t.integer :project_id
      t.text :channel_id

      t.timestamps
    end
  end
end
