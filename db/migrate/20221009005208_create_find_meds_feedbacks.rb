class CreateFindMedsFeedbacks < ActiveRecord::Migration[5.1]
  def change
    create_table :find_meds_feedbacks do |t|
      t.text :text
      t.jsonb :data
      t.text :state
      t.datetime :deleted_at
      t.integer :project_id

      t.timestamps
    end
  end
end
