class CreateListaiPages < ActiveRecord::Migration[5.1]
  def change
    create_table :listai_pages do |t|
      t.integer :number
      t.text :file

      t.timestamps
    end
  end
end
