class CreateTramwayEventPlaces < ActiveRecord::Migration[5.1]
  def change
    create_table :tramway_event_places do |t|
      t.text :title
      t.text :description
      t.point :coordinates
      t.text :photo
      t.text :city
      t.text :state, default: :active

      t.timestamps
    end
  end
end
