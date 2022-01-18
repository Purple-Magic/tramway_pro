# frozen_string_literal: true

class BotTelegram::Custom::Scenario
  include ::BotTelegram::MessagesManager
  include ::BotTelegram::Info

  attr_reader :bot, :bot_record, :chat, :message_from_telegram, :message, :user

  def initialize(**options)
    @bot = options[:bot]
    @message_from_telegram = options[:message_from_telegram]
    @bot_record = options[:bot_record]
    @chat = options[:chat]
    @message = options[:message]
    @user = options[:user]
  end
end
