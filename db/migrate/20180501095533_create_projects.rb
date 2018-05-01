class CreateProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :projects do |t|
      t.text :title
      t.text :description
      t.text :url

      t.timestamps
    end
  end
end
