# frozen_string_literal: true

class BotTelegram::Chat < ApplicationRecord
  self.table_name = :bot_telegram_chats

  def private?
    chat_type == 'private'
  end
end
