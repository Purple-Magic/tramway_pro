# frozen_string_literal: true

class CreateTramwayLandingForms < ActiveRecord::Migration[5.1]
  def change
    create_table :tramway_landing_forms do |t|
      t.text :title
      t.text :form_name
      t.integer :block_id
      t.integer :position
      t.text :state, default: :active

      t.timestamps
    end
  end
end
