class CreateFindMedsComponents < ActiveRecord::Migration[5.1]
  def change
    create_table :find_meds_components do |t|
      t.text :name
      t.text :comment
      t.text :airtable_id
      t.text :state
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
