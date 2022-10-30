class CreateItWayContents < ActiveRecord::Migration[5.1]
  def change
    create_table :it_way_contents do |t|
      t.text :content_type
      t.integer :associated_id
      t.text :associated_type
      t.datetime :deleted_at
      t.text :state
      t.text :title
      t.integer :project_id

      t.timestamps
    end
  end
end
