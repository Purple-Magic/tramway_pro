class CreateBenchkillerCompanies < ActiveRecord::Migration[5.1]
  def change
    create_table :benchkiller_companies do |t|
      t.text :title
      t.jsonb :data
      t.text :state
      t.integer :project_id

      t.timestamps
    end
  end
end
