class AddStatesToTelegramModels < ActiveRecord::Migration[5.1]
  def change
    add_column :bot_telegram_users, :state, :text
    add_column :bot_telegram_chats, :state, :text
    add_column :bot_telegram_messages, :state, :text
  end
end
