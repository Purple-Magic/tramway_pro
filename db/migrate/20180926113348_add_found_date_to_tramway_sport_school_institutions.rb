class AddFoundDateToTramwaySportSchoolInstitutions < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_sport_school_institutions, :found_date, :date
  end
end
