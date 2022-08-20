class CreateFindMedsConcentrations < ActiveRecord::Migration[5.1]
  def change
    create_table :find_meds_concentrations do |t|
      t.integer :component_id
      t.text :name
      t.jsonb :values
      t.text :airtable_id
      t.text :state
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
