class AddBookIdToListaiPages < ActiveRecord::Migration[5.1]
  def change
    add_column :listai_pages, :book_id, :integer
  end
end
