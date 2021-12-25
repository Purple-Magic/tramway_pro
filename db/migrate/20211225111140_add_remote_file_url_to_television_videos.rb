class AddRemoteFileUrlToTelevisionVideos < ActiveRecord::Migration[5.1]
  def change
    add_column :television_videos, :remote_file_path, :text
  end
end
