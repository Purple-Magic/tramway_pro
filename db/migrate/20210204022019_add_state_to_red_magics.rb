class AddStateToRedMagics < ActiveRecord::Migration[5.1]
  def change
    add_column :red_magics, :state, :text
  end
end
