class CreateTelegramChats < ActiveRecord::Migration[5.1]
  def change
    create_table :bot_telegram_chats do |t|
      t.integer :telegram_id
      t.text :title
      t.text :chat_type
      t.jsonb :options

      t.timestamps
    end
  end
end
