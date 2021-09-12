# frozen_string_literal: true

require_relative 'it_way_pro'
require_relative 'it_way_pro/words_check'
require_relative 'commands'
require_relative 'command'

class BotTelegram::Leopold::Scenario
  include ::BotTelegram::MessagesManager
  include ::BotTelegram::Info
  include ::BotTelegram::Leopold::ItWayPro
  include ::BotTelegram::Leopold::ChatsConcern

  BOT_ID = 9

  attr_reader :bot, :bot_record, :chat, :message_from_telegram, :message

  def initialize(message_from_telegram, bot, bot_record, chat, message)
    @bot = bot
    @message_from_telegram = message_from_telegram
    @bot_record = bot_record
    @chat = chat
    @message = message
  end

  def run
    chat_decorator = BotTelegram::Leopold::ChatDecorator.new chat
    text = message_from_telegram.text
    if chat_decorator.to_answer?
      command = BotTelegram::Leopold::Command.new text
      if command.valid?
        command.run
      else
        it_way_process text
      end
    else
      chat_id = chat.telegram_chat_id.to_s
      message_to_chat bot, chat, bot_record.options['not_my_group'] unless exceptions.values.include? chat_id
    end
  end
end
