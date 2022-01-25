class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.text :title
      t.text :state
      t.datetime :deleted_at
      t.integer :project_id

      t.timestamps
    end
  end
end
