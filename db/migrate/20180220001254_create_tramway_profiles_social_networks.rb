class CreateTramwayProfilesSocialNetworks < ActiveRecord::Migration[5.1]
  def change
    create_table :tramway_profiles_social_networks do |t|
      t.text :title
      t.text :uid
      t.text :url
      t.text :record_id
      t.text :record_type
      t.text :network_name
      t.text :state, default: :active

      t.timestamps
    end
  end
end
