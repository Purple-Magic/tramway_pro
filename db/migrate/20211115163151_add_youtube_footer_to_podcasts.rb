class AddYoutubeFooterToPodcasts < ActiveRecord::Migration[5.1]
  def change
    add_column :podcasts, :youtube_footer, :text
  end
end
