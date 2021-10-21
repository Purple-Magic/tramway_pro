class AddMessageTypeToBotTelegramMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :bot_telegram_messages, :message_type, :text, default: :regular
  end
end
