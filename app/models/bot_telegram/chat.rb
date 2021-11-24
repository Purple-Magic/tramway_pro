# frozen_string_literal: true

class BotTelegram::Chat < ApplicationRecord
  has_many :messages, class_name: 'BotTelegram::Message'
  self.table_name = :bot_telegram_chats

  def private?
    chat_type == 'private'
  end
end
