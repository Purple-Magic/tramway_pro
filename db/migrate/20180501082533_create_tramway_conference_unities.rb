class CreateTramwayConferenceUnities < ActiveRecord::Migration[5.1]
  def change
    create_table :tramway_conference_unities do |t|
      t.text :title
      t.text :tagline

      t.text :logo

      t.text :address
      t.text :phone

      t.text :latitude
      t.text :longtitude

      t.text :state, default: :active
      t.text :view_state, default: :hidden

      t.timestamps
    end
  end
end
