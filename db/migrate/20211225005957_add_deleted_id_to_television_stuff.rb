class AddDeletedIdToTelevisionStuff < ActiveRecord::Migration[5.1]
  def change
    add_column :television_channels, :deleted_at, :datetime
    add_column :television_videos, :deleted_at, :datetime
    add_column :television_schedule_items, :deleted_at, :datetime
  end
end
