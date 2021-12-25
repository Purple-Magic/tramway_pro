class AddStateToTelevisionChannels < ActiveRecord::Migration[5.1]
  def change
    add_column :television_channels, :state, :text
  end
end
