class BotTelegram::User < ApplicationRecord
  self.table_name = :bot_telegram_users

  has_many :messages, class_name: 'BotTelegram::Message'

  search_by :first_name, :username, :last_name
end
