class AddStateToBots < ActiveRecord::Migration[5.1]
  def change
    add_column :bots, :state, :text
  end
end
