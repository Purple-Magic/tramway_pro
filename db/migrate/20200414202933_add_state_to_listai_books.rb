class AddStateToListaiBooks < ActiveRecord::Migration[5.1]
  def change
    add_column :listai_books, :state, :text
  end
end
