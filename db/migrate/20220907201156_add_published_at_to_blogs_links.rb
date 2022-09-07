class AddPublishedAtToBlogsLinks < ActiveRecord::Migration[5.1]
  def change
    add_column :blogs_links, :published_at, :datetime
  end
end
