class CreateTramwaySportSchoolKindSports < ActiveRecord::Migration[5.1]
  def change
    create_table :tramway_sport_school_kind_sports do |t|
      t.text :title

      t.timestamps
    end
  end
end
