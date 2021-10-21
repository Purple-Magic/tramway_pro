# frozen_string_literal: true

class BotTelegram::Custom::Scenario
  include ::BotTelegram::MessagesManager
  include ::BotTelegram::Info

  attr_reader :bot, :bot_record, :chat, :message_from_telegram, :message, :user

  def initialize(message_from_telegram, bot, bot_record, chat, message, user)
    @bot = bot
    @message_from_telegram = message_from_telegram
    @bot_record = bot_record
    @chat = chat
    @message = message
    @user = user
  end
end
