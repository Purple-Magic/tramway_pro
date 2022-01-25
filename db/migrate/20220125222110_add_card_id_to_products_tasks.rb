class AddCardIdToProductsTasks < ActiveRecord::Migration[5.1]
  def change
    add_column :products_tasks, :card_id, :text
  end
end
