# frozen_string_literal: true

class BotTelegram::Custom::Scenario
  include ::BotTelegram::MessagesManager
  include ::BotTelegram::Info

  attr_reader :bot, :bot_record, :chat, :message_from_telegram, :message

  def initialize(message_from_telegram, bot, bot_record, chat, message)
    @bot = bot
    @message_from_telegram = message_from_telegram
    @bot_record = bot_record
    @chat = chat
    @message = message
  end
end
