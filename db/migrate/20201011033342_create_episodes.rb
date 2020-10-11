class CreateEpisodes < ActiveRecord::Migration[5.1]
  def change
    create_table :episodes do |t|
      t.integer :podcast_id
      t.text :title
      t.integer :number
      t.integer :season
      t.text :description
      t.datetime :published_at
      t.text :image
      t.text :explicit

      t.timestamps
    end
  end
end
