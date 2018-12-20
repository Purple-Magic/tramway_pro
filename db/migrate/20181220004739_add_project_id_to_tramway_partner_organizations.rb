class AddProjectIdToTramwayPartnerOrganizations < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_partner_organizations, :project_id, :integer
  end
end
