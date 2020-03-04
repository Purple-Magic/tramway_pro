# frozen_string_literal: true

class RemoveStatusFromTramwayEventEvents < ActiveRecord::Migration[5.1]
  def change
    remove_column :tramway_event_events, :status
  end
end
