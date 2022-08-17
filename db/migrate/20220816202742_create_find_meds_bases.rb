class CreateFindMedsBases < ActiveRecord::Migration[5.1]
  def change
    create_table :find_meds_bases do |t|
      t.text :name
      t.text :key
      t.text :state
      t.datetime :deleted_at
      t.integer :project_id

      t.timestamps
    end
  end
end
