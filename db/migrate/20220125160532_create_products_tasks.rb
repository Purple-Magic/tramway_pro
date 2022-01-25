class CreateProductsTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :products_tasks do |t|
      t.text :title
      t.jsonb :data
      t.text :state
      t.datetime :deleted_at
      t.integer :project_id
      t.integer :product_id

      t.timestamps
    end
  end
end
