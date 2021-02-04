class AddTitleToRedMagics < ActiveRecord::Migration[5.1]
  def change
    add_column :red_magics, :title, :text
  end
end
