class AddBotIdToBotTelegramChats < ActiveRecord::Migration[5.1]
  def change
    add_column :bot_telegram_chats, :bot_id, :integer
  end
end
