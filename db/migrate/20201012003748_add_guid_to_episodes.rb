class AddGuidToEpisodes < ActiveRecord::Migration[5.1]
  def change
    add_column :episodes, :guid, :uuid
  end
end
