class AddDefaultImageToPodcasts < ActiveRecord::Migration[5.1]
  def change
    add_column :podcasts, :default_image, :text
  end
end
