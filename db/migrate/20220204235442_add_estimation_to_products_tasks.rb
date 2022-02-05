class AddEstimationToProductsTasks < ActiveRecord::Migration[5.1]
  def change
    add_column :products_tasks, :estimation, :text
  end
end
