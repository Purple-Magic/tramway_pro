class AddMainImageToPurpleMagics < ActiveRecord::Migration[5.1]
  def change
    add_column :purple_magics, :main_image, :text
  end
end
