class AddBotTelegramMessagesSender < ActiveRecord::Migration[5.1]
  def change
    add_column :bot_telegram_messages, :sender, :text, default: :user
  end
end
