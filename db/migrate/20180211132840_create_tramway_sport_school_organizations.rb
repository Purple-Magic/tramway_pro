class CreateTramwaySportSchoolOrganizations < ActiveRecord::Migration[5.1]
  def change
    create_table :tramway_sport_school_organizations do |t|
      t.text :title
      t.text :description
      t.text :logo
      t.text :organization_type, default: :required
      t.text :link
      t.text :state, default: :active
      t.text :view_state, default: :hidden

      t.timestamps
    end
  end
end
