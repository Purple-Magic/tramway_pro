class AddUuidToBenchkillerDeliveries < ActiveRecord::Migration[5.1]
  def change
    add_column :benchkiller_deliveries, :uuid, :uuid, default: -> { "uuid_generate_v4()" }
  end
end
