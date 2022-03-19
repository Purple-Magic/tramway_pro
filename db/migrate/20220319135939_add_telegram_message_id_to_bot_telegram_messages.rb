class AddTelegramMessageIdToBotTelegramMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :bot_telegram_messages, :telegram_message_id, :integer
  end
end
