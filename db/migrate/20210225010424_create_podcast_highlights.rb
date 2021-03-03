class CreatePodcastHighlights < ActiveRecord::Migration[5.1]
  def change
    create_table :podcast_highlights do |t|
      t.integer :podcast_id
      t.datetime :time
      t.text :state
      t.integer :project_id

      t.timestamps
    end
  end
end
