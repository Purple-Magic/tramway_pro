class AddDescriptionFooterToPodcasts < ActiveRecord::Migration[5.1]
  def change
    add_column :podcasts, :footer, :text
  end
end
