class CreateTramwayDevs < ActiveRecord::Migration[5.1]
  def change
    create_table :tramway_devs do |t|
      t.text :name
      t.text :public_name
      t.text :tagline
      t.text :address
      t.text :phone
      t.point :coordinates
      t.text :state

      t.timestamps
    end
  end
end
