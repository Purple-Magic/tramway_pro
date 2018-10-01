class CreateTramwayEventPeople < ActiveRecord::Migration[5.1]
  def change
    create_table :tramway_event_people do |t|
      t.text :first_name
      t.text :last_name
      t.text :photo
      t.text :state, default: :active

      t.timestamps
    end
  end
end
