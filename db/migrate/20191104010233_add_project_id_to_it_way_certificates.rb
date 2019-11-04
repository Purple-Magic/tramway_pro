class AddProjectIdToItWayCertificates < ActiveRecord::Migration[5.1]
  def change
    add_column :it_way_certificates, :project_id, :integer
  end
end
