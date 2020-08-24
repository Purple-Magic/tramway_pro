class AddTitleToPurpleMagic < ActiveRecord::Migration[5.1]
  def change
  	add_column :purple_magics, :title, :text
  end
end
