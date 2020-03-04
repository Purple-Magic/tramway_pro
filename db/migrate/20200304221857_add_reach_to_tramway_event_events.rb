# frozen_string_literal: true

class AddReachToTramwayEventEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_event_events, :reach, :text
  end
end
