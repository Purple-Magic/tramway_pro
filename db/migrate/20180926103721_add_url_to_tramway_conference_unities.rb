class AddUrlToTramwayConferenceUnities < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_conference_unities, :url, :text
  end
end
