# frozen_string_literal: true

require_relative '../custom/scenario'
require_relative 'chat_decorator'
require_relative 'command'
require_relative 'commands'
require_relative 'action'

class BotTelegram::BenchkillerBot::Scenario < ::BotTelegram::Custom::Scenario
  include ::BotTelegram::BenchkillerBot::Commands

  BOT_ID = 13

  def run
    chat_decorator = BotTelegram::BenchkillerBot::ChatDecorator.new chat
    if chat_decorator.to_answer?
      if message_from_telegram.is_a?(Telegram::Bot::Types::CallbackQuery) || user.finished_state_for?(bot: bot_record)
        command = BotTelegram::BenchkillerBot::Command.new message_from_telegram, bot_record.slug
        public_send command.name, command.argument if command.valid?
      else
        action = BotTelegram::BenchkillerBot::Action.new message_from_telegram, user, chat, bot, bot_record
        action.run
      end
    else
      chat_id = chat.telegram_chat_id.to_s
      message_to_chat bot, chat, bot_record.options['not_my_group'] unless exceptions.values.include? chat_id
    end
  end
end
