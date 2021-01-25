class AddTelegramChatIdToBotTelegramChats < ActiveRecord::Migration[5.1]
  def change
    add_column :bot_telegram_chats, :telegram_chat_id, :text
  end
end
