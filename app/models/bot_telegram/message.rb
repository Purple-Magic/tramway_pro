# frozen_string_literal: true

class BotTelegram::Message < ApplicationRecord
  self.table_name = :bot_telegram_messages

  belongs_to :user, class_name: 'BotTelegram::User', optional: true
end
