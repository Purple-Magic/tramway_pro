class AddDataToBotTelegramUsersStates < ActiveRecord::Migration[5.1]
  def change
    add_column :bot_telegram_users_states, :data, :jsonb
  end
end
