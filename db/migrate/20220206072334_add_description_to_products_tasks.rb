class AddDescriptionToProductsTasks < ActiveRecord::Migration[5.1]
  def change
    add_column :products_tasks, :description, :text
  end
end
