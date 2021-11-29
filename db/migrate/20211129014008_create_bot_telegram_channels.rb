class CreateBotTelegramChannels < ActiveRecord::Migration[5.1]
  def change
    create_table :bot_telegram_channels do |t|
      t.integer :bot_id
      t.text :title
      t.text :state
      t.integer :project_id
      t.text :telegram_channel_id

      t.timestamps
    end
  end
end
