class AddTelegramIdToBotTelegramUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :bot_telegram_users, :telegram_id, :text
  end
end
