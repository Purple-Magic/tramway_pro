# frozen_string_literal: true

class CreateTramwayLandingTools < ActiveRecord::Migration[5.1]
  def change
    create_table :tramway_landing_tools do |t|
      t.text :title
      t.text :account_id
      t.jsonb :options
      t.text :state, default: :active

      t.timestamps
    end
  end
end
