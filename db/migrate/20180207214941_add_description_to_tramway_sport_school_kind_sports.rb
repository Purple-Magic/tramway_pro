class AddDescriptionToTramwaySportSchoolKindSports < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_sport_school_kind_sports, :description, :text
  end
end
