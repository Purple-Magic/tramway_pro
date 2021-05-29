class AddUuidToTramwayNewsNews < ActiveRecord::Migration[5.1]
  def change
    add_column :tramway_news_news, :uuid, :uuid, default: -> { "uuid_generate_v4()" }
  end
end
