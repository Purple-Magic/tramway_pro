class AddLlToTramwaySportSchoolInstitutions < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_sport_school_institutions, :latitude, :text
    add_column :tramway_sport_school_institutions, :longtitude, :text
  end
end
