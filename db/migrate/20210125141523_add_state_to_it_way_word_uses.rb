class AddStateToItWayWordUses < ActiveRecord::Migration[5.1]
  def change
    add_column :it_way_word_uses, :state, :text
  end
end
