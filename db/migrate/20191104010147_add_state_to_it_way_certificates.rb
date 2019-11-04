class AddStateToItWayCertificates < ActiveRecord::Migration[5.1]
  def change
    add_column :it_way_certificates, :state, :text
  end
end
