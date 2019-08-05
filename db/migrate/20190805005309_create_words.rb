class CreateWords < ActiveRecord::Migration[5.1]
  def change
    create_table :words do |t|
      t.text :main
      t.text :synonims, array: true
      t.text :description
      t.text :state

      t.timestamps
    end
  end
end
