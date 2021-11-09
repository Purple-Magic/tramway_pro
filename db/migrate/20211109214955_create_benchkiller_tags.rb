class CreateBenchkillerTags < ActiveRecord::Migration[5.1]
  def change
    create_table :benchkiller_tags do |t|
      t.text :title
      t.integer :project_id
      t.text :state

      t.timestamps
    end
  end
end
