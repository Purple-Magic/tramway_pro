class CreateTramwayNewsNews < ActiveRecord::Migration[5.1]
  def change
    create_table :tramway_news_news do |t|
      t.text :title
      t.text :body
      t.datetime :published_at
      t.text :photo
      t.text :state, default: :active

      t.timestamps
    end
  end
end
