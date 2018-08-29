class CreateTramwayEventEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :tramway_event_events do |t|
      t.text :title
      t.text :description
      t.datetime :begin_date
      t.datetime :end_date
      t.text :state, default: :active

      t.timestamps
    end
  end
end
