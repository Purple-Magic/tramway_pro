# frozen_string_literal: true

class BotTelegram::Message < ApplicationRecord
  self.table_name = :bot_telegram_messages

  belongs_to :user, class_name: 'BotTelegram::User', optional: true
  belongs_to :bot, class_name: 'Bot'

  enumerize :sender, in: [ :bot, :user ], default: :user
end
