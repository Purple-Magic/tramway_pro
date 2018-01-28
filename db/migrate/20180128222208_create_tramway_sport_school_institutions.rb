class CreateTramwaySportSchoolInstitutions < ActiveRecord::Migration[5.1]
  def change
    create_table :tramway_sport_school_institutions do |t|
      t.text :title
      t.text :tagline
      t.text :logo
      t.text :state, default: :active

      t.timestamps
    end
  end
end
