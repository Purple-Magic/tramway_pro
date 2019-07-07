class CreateTramwaySitePeople < ActiveRecord::Migration[5.1]
  def change
    create_table :tramway_site_people do |t|
      t.text :names, array: true
      t.text :short_bio
      t.text :bio
      t.text :photo

      t.text :state, default: :active

      t.timestamps
    end
  end
end
