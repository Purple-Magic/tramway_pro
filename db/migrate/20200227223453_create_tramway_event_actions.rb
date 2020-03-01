# frozen_string_literal: true

class CreateTramwayEventActions < ActiveRecord::Migration[5.1]
  def change
    create_table :tramway_event_actions do |t|
      t.integer :event_id
      t.text :title
      t.datetime :deadline
      t.text :action_state, default: :must_be_done
      t.text :state, default: :active

      t.timestamps
    end
  end
end
