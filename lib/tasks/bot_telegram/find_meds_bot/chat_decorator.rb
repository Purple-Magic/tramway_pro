# frozen_string_literal: true

class BotTelegram::FindMedsBot::ChatDecorator
  def initialize(chat)
    @chat = chat
  end

  def to_answer?
    @chat.private? || admin_chat?
  end

  def main_chat?
    @chat.telegram_chat_id == ::BotTelegram::FindMedsBot::MAIN_CHAT_ID
  end

  def admin_chat?
    @chat.telegram_chat_id == ::BotTelegram::FindMedsBot::ADMIN_CHAT_ID
  end
end
