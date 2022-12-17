class AddUrlToPodcasts < ActiveRecord::Migration[5.1]
  def change
    add_column :podcasts, :url, :text
  end
end
