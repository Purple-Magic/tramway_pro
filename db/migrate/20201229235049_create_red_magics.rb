class CreateRedMagics < ActiveRecord::Migration[5.1]
  def change
    create_table :red_magics do |t|
      t.text :name
      t.text :public_name
      t.text :tagline
      t.text :address
      t.text :phone
      t.point :coordinates
      t.text :text
      t.text :main_image
      t.text :favicon
      t.integer :project_id

      t.timestamps
    end
  end
end
