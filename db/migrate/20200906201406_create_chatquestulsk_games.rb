class CreateChatquestulskGames < ActiveRecord::Migration[5.1]
  def change
    create_table :chatquestulsk_games do |t|
      t.text :area
      t.integer :bot_telegram_user_id
      t.text :state

      t.timestamps
    end
  end
end
