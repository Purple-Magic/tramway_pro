class CreateTramwayEventSections < ActiveRecord::Migration[5.1]
  def change
    create_table :tramway_event_sections do |t|
      t.integer :event_id
      t.text :title
      t.text :description
      t.text :photo
      t.text :state, default: :active

      t.timestamps
    end
  end
end
