class CreateTramwayPartnerOrganizations < ActiveRecord::Migration[5.1]
  def change
    create_table :tramway_partner_organizations do |t|
      t.text :title
      t.text :logo
      t.text :url
      t.text :state, default: :active

      t.timestamps
    end
  end
end
