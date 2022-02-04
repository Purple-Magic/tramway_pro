# frozen_string_literal: true

require_relative '../custom/scenario'
require_relative 'chat_decorator'
require_relative 'command'
require_relative 'commands'
require_relative 'action'

class BotTelegram::BenchkillerBot::Scenario < ::BotTelegram::Custom::Scenario
  include ::BotTelegram::BenchkillerBot::Commands
  include ::BotTelegram::BenchkillerBot::AdminFeatures
  include ::BotTelegram::BenchkillerBot::Concern

  BOT_ID = 13

  def run
    return if user.is_a? BotTelegram::Channel

    chat_decorator = BotTelegram::BenchkillerBot::ChatDecorator.new chat
    if chat_decorator.main_chat?
      offer = ::Benchkiller::Offer.create! message_id: message.id
      offer.parse!
      send_approve_message_to_admin_chat offer
    end

    return unless chat_decorator.to_answer?

    if message_from_telegram.text == '/start'
      start
    elsif message_from_telegram.text.in? ::BotTelegram::BenchkillerBot::BUTTONS.values
      public_send ::BotTelegram::BenchkillerBot::BUTTONS.invert[message_from_telegram.text], nil
    elsif user.finished_state_for?(bot: bot_record)
      process_new_action
    else
      action = BotTelegram::BenchkillerBot::Action.new message_from_telegram, user, chat, bot, bot_record
      action.run
    end
  end

  private

  def process_new_action
    if message_from_telegram.is_a? Telegram::Bot::Types::CallbackQuery
      command = BotTelegram::BenchkillerBot::Command.new message_from_telegram, bot_record.slug
      public_send command.name, command.argument if command.valid?
    else
      message_to_chat bot.api, chat.telegram_chat_id, 'Напиши /start'
    end
  end
end
