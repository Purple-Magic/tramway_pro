class AddProjectIdsToTelegramMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :bot_telegram_users, :project_id, :integer
    add_column :bot_telegram_chats, :project_id, :integer
    add_column :bot_telegram_messages, :project_id, :integer
  end
end
