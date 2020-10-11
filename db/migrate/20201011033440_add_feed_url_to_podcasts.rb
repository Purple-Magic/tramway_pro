class AddFeedUrlToPodcasts < ActiveRecord::Migration[5.1]
  def change
    add_column :podcasts, :feed_url, :text
  end
end
