class AddTechNameToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :tech_name, :text
  end
end
