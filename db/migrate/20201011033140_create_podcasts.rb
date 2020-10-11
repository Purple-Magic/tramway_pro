class CreatePodcasts < ActiveRecord::Migration[5.1]
  def change
    create_table :podcasts do |t|
      t.text :title

      t.timestamps
    end
  end
end
