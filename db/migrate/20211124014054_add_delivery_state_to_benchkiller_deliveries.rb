class AddDeliveryStateToBenchkillerDeliveries < ActiveRecord::Migration[5.1]
  def change
    add_column :benchkiller_deliveries, :delivery_state, :text
  end
end
