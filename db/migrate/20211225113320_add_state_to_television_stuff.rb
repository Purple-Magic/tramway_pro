class AddStateToTelevisionStuff < ActiveRecord::Migration[5.1]
  def change
    add_column :television_videos, :state, :text
    add_column :television_schedule_items, :state, :text
  end
end
