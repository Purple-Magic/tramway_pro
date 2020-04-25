class CreatePurpleMagics < ActiveRecord::Migration[5.1]
  def change
    create_table :purple_magics do |t|
      t.text :name
      t.text :public_name
      t.text :tagline
      t.text :address
      t.text :phone
      t.point :coordinates
      t.string :state
      t.string :text
      t.text :favicon

      t.timestamps
    end
  end
end
