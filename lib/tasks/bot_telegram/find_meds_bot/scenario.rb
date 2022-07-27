# frozen_string_literal: true

require_relative '../custom/scenario'
require_relative 'chat_decorator'
require_relative 'command'
require_relative 'commands'
require_relative 'action'

class BotTelegram::FindMedsBot::Scenario < ::BotTelegram::Custom::Scenario
  include ::BotTelegram::FindMedsBot::Commands
  include ::BotTelegram::FindMedsBot::AdminFeatures
  include ::BotTelegram::FindMedsBot::Concern

  BOT_ID = 13

  def run
    chat_decorator = BotTelegram::FindMedsBot::ChatDecorator.new chat

    return unless chat_decorator.to_answer?

    if message_from_telegram.is_a? Telegram::Bot::Types::CallbackQuery
      command = BotTelegram::FindMedsBot::Command.new message_from_telegram, bot_record.slug
      public_send command.name, command.argument if command.valid?
    else
      if start_action?
        start
      elsif button_action?
        public_send ::BotTelegram::FindMedsBot::BUTTONS.invert[message_from_telegram.text], nil
      elsif user.finished_state_for?(bot: bot_record)
        message_to_chat bot.api, chat.telegram_chat_id, 'Напиши /start'
      else
        action = BotTelegram::FindMedsBot::Action.new message_from_telegram, user, chat, bot, bot_record
        action.run
      end
    end
  end

  private

  def start_action?
    message_from_telegram.try(:text) && message_from_telegram.text == '/start'
  end

  def button_action?
    message_from_telegram.try(:text) && message_from_telegram.text.in?(::BotTelegram::FindMedsBot::BUTTONS.values)
  end
end
