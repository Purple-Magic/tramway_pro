class AddProjectIdToScheduleItems < ActiveRecord::Migration[5.1]
  def change
    add_column :television_schedule_items, :project_id, :integer
    add_column :television_schedule_items, :channel_id, :integer
  end
end
