class AddRequestPeriodToTramwayEventEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_event_events, :request_collecting_begin_date, :datetime
    add_column :tramway_event_events, :request_collecting_end_date, :datetime
  end
end
