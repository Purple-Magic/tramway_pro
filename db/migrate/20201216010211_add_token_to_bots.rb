class AddTokenToBots < ActiveRecord::Migration[5.1]
  def change
    add_column :bots, :token, :text
  end
end
