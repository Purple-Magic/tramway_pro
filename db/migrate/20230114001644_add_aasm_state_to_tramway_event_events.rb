class AddAasmStateToTramwayEventEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_event_events, :aasm_state, :string
  end
end
