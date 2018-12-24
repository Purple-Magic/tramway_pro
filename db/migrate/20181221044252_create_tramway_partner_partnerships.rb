class CreateTramwayPartnerPartnerships < ActiveRecord::Migration[5.1]
  def change
    create_table :tramway_partner_partnerships do |t|
      t.integer :organization_id
      t.integer :partner_id
      t.text :partner_type
      t.text :partnership_type
      t.text :state, default: :active

      t.timestamps
    end
  end
end
