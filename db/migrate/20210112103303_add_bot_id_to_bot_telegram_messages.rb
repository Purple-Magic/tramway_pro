class AddBotIdToBotTelegramMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :bot_telegram_messages, :bot_id, :integer
  end
end
