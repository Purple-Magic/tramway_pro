class CreateTelegramMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :bot_telegram_messages do |t|
      t.integer :chat_id
      t.integer :user_id
      t.text :text
      t.jsonb :options

      t.timestamps
    end
  end
end
