class AddPublicNameToTramwayConferenceUnities < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_conference_unities, :public_name, :text
  end
end
