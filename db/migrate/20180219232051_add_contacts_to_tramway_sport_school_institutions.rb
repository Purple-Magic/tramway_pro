class AddContactsToTramwaySportSchoolInstitutions < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_sport_school_institutions, :address, :text
    add_column :tramway_sport_school_institutions, :phone, :text
  end
end
