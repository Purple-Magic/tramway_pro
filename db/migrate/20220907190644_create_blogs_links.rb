class CreateBlogsLinks < ActiveRecord::Migration[5.1]
  def change
    create_table :blogs_links do |t|
      t.text :url
      t.datetime :deleted_at
      t.text :state
      t.text :image
      t.text :title
      t.text :lead
      t.integer :project_id

      t.timestamps
    end
  end
end
