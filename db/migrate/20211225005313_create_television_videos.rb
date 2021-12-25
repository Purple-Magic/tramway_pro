class CreateTelevisionVideos < ActiveRecord::Migration[5.1]
  def change
    create_table :television_videos do |t|
      t.text :title
      t.text :file
      t.integer :project_id

      t.timestamps
    end
  end
end
