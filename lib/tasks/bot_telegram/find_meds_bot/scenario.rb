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

  BOT_ID = 14

  def run
    chat_decorator = BotTelegram::FindMedsBot::ChatDecorator.new chat

    return unless chat_decorator.to_answer?

    case action
    when :callback_query
      command = BotTelegram::FindMedsBot::Command.new message_from_telegram, bot_record.slug
      public_send command.name, command.argument if command.valid?
    when :start
      start
    when :button
      public_send ::BotTelegram::FindMedsBot.buttons.invert[message_from_telegram.text], nil
    when :new_run
      message_to_chat bot.api, chat.telegram_chat_id, 'Напиши /start'
    else
      action = BotTelegram::FindMedsBot::Action.new message_from_telegram, user, chat, bot, bot_record
      action.run
    end
  end

  private

  def action
    return :start if start_action?
    return :callback_query if message_from_telegram.is_a? Telegram::Bot::Types::CallbackQuery
    return :button if button_action?
    return :new_run if user.finished_state_for?(bot: bot_record)

    :bot_action
  end

  def start_action?
    message_from_telegram.try(:text) && message_from_telegram.text == '/start'
  end

  def button_action?
    message_from_telegram.try(:text) && message_from_telegram.text.in?(::BotTelegram::FindMedsBot.buttons.values)
  end
end
