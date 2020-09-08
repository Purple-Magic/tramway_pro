class CreateTelegramUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :bot_telegram_users do |t|
      t.text :first_name
      t.text :last_name
      t.text :username
      t.jsonb :options

      t.timestamps
    end
  end
end
