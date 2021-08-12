class AddMoreColumnsToPodcastHighglights < ActiveRecord::Migration[5.1]
  def change
    add_column :podcast_highlights, :using_state, :text
    add_column :podcast_highlights, :cut_begin_time, :text
    add_column :podcast_highlights, :cut_end_time, :text
    add_column :podcast_highlights, :trailer_position, :integer
  end
end
