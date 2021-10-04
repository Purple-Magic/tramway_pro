# frozen_string_literal: true

class BotTelegram::Message < ApplicationRecord
  self.table_name = :bot_telegram_messages

  belongs_to :user, class_name: 'BotTelegram::User', optional: true
  belongs_to :bot, class_name: 'Bot'
  belongs_to :chat, class_name: 'BotTelegram::Chat', optional: true
end
