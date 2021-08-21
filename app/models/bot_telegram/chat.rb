# frozen_string_literal: true

class BotTelegram::Chat < ApplicationRecord
  self.table_name = :bot_telegram_chats

  enumerize :chat_type, in: %i[private public], default: :private
end
