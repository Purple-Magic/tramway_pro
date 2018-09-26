class AddFoundDateToTramwayConferenceUnities < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_conference_unities, :found_date, :date
  end
end
