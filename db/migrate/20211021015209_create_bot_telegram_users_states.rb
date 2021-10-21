class CreateBotTelegramUsersStates < ActiveRecord::Migration[5.1]
  def change
    create_table :bot_telegram_users_states do |t|
      t.integer :user_id
      t.integer :bot_id
      t.text :current_state
      t.text :state

      t.timestamps
    end
  end
end
