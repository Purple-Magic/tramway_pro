class CreateListaiBooks < ActiveRecord::Migration[5.1]
  def change
    create_table :listai_books do |t|
      t.text :title

      t.timestamps
    end
  end
end
