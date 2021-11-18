class AddUuidToBenchkillerOffers < ActiveRecord::Migration[5.1]
  def change
    add_column :benchkiller_offers, :uuid, :uuid, default: -> { "uuid_generate_v4()" }
  end
end
