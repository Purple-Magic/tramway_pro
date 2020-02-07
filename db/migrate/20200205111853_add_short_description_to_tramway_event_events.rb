# frozen_string_literal: true

class AddShortDescriptionToTramwayEventEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_event_events, :short_description, :text
  end
end
