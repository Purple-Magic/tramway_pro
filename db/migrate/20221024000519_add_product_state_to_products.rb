class AddProductStateToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :product_state, :text, default: :in_progress
  end
end
