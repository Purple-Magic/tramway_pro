class AddProjectIdToTramwayPartnerPartnerships < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_partner_partnerships, :project_id, :integer
  end
end
