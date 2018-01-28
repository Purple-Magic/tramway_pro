class AddDescriptionToTramwaySportSchoolTrainers < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_sport_school_trainers, :description, :text
  end
end
