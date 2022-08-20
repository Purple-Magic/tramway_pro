class CreateFindMedsDrugs < ActiveRecord::Migration[5.1]
  def change
    create_table :find_meds_drugs do |t|
      t.text :name
      t.text :comment
      t.text :patent
      t.text :airtable_id
      t.datetime :deleted_at
      t.text :state

      t.timestamps
    end
  end
end
