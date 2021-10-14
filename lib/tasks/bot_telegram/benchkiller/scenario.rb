# frozen_string_literal: true

require_relative '../custom/scenario'

class BotTelegram::Benchkiller::Scenario < ::BotTelegram::Custom::Scenario
  include ::BotTelegram::Benchkiller::Commands

  BOT_ID = 13

  def run
    chat_decorator = BotTelegram::Benchkiller::ChatDecorator.new chat
    text = message_from_telegram.text
    if chat_decorator.to_answer?
      command = BotTelegram::Benchkiller::Command.new text, bot_record.slug
      public_send command.name, command.argument if command.valid?
    else
      chat_id = chat.telegram_chat_id.to_s
      message_to_chat bot, chat, bot_record.options['not_my_group'] unless exceptions.values.include? chat_id
    end
  end
end
