class CreateTramwaySportSchoolDocuments < ActiveRecord::Migration[5.1]
  def change
    create_table :tramway_sport_school_documents do |t|
      t.text :title
      t.text :file
      t.text :state, default: :active
      t.text :view_state, default: :hidden

      t.timestamps
    end
  end
end
