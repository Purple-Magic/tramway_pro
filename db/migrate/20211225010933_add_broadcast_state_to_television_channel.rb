class AddBroadcastStateToTelevisionChannel < ActiveRecord::Migration[5.1]
  def change
    add_column :television_channels, :broadcast_state, :text
  end
end
