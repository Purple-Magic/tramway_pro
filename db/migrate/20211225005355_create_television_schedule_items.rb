class CreateTelevisionScheduleItems < ActiveRecord::Migration[5.1]
  def change
    create_table :television_schedule_items do |t|
      t.integer :video_id
      t.text :schedule_type
      t.jsonb :options

      t.timestamps
    end
  end
end
