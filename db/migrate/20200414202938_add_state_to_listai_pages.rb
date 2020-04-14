class AddStateToListaiPages < ActiveRecord::Migration[5.1]
  def change
    add_column :listai_pages, :state, :text
  end
end
