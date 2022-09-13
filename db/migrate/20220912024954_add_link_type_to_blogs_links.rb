class AddLinkTypeToBlogsLinks < ActiveRecord::Migration[5.1]
  def change
    add_column :blogs_links, :link_type, :text
  end
end
