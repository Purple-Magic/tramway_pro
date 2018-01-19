class AddImageToTramwaySportSchoolKindSports < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_sport_school_kind_sports, :image, :text
  end
end
