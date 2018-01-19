class AddDegreeToTramwaySportSchoolTrainers < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_sport_school_trainers, :degree, :text
    add_column :tramway_sport_school_trainers, :photo, :text
  end
end
