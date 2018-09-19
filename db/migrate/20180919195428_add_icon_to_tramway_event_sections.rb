class AddIconToTramwayEventSections < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_event_sections, :icon, :text
  end
end
