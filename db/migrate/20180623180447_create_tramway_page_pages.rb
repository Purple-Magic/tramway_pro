class CreateTramwayPagePages < ActiveRecord::Migration[5.1]
  def change
    create_table :tramway_page_pages do |t|
      t.text :title
      t.text :body
      t.text :slug
      t.text :state, default: :active

      t.timestamps
    end
  end
end
