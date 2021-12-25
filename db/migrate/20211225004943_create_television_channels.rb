class CreateTelevisionChannels < ActiveRecord::Migration[5.1]
  def change
    create_table :television_channels do |t|
      t.text :title
      t.text :channel_type
      t.jsonb :rtmp
      t.integer :project_id

      t.timestamps
    end
  end
end
