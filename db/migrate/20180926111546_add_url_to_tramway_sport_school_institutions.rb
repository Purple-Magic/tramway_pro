class AddUrlToTramwaySportSchoolInstitutions < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_sport_school_institutions, :url, :text
  end
end
