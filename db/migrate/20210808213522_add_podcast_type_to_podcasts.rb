class AddPodcastTypeToPodcasts < ActiveRecord::Migration[5.1]
  def change
    add_column :podcasts, :podcast_type, :text
  end
end
