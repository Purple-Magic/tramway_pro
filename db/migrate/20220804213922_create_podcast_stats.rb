class CreatePodcastStats < ActiveRecord::Migration[5.1]
  def change
    create_table :podcast_stats do |t|
      t.integer :month
      t.integer :year
      t.integer :podcast_id
      t.text :service
      t.integer :downloads
      t.integer :streams
      t.integer :listeners
      t.float :hours
      t.float :average_listenning
      t.float :overhearing_percent
      t.datetime :deleted_at
      t.integer :project_id
      t.string :state

      t.timestamps
    end
  end
end
