# frozen_string_literal: true

require_relative '../custom/scenario'
require_relative 'chat_decorator'
require_relative 'command'
require_relative 'commands'
require_relative 'action'
require_relative 'notify'

class BotTelegram::BenchkillerBot::Scenario < ::BotTelegram::Custom::Scenario
  include ::BotTelegram::BenchkillerBot::Commands
  include ::BotTelegram::BenchkillerBot::Notify

  BOT_ID = 13

  def run
    chat_decorator = BotTelegram::BenchkillerBot::ChatDecorator.new chat
    if chat_decorator.main_chat?
      offer = ::Benchkiller::Offer.create! message_id: message.id
      send_approve_message_to_admin_chat offer
    end
    if chat_decorator.to_answer?
      if message_from_telegram.is_a?(Telegram::Bot::Types::CallbackQuery) || user.finished_state_for?(bot: bot_record)
        command = BotTelegram::BenchkillerBot::Command.new message_from_telegram, bot_record.slug
        public_send command.name, command.argument if command.valid?
      else
        action = BotTelegram::BenchkillerBot::Action.new message_from_telegram, user, chat, bot, bot_record
        action.run
      end
    end
  end

  private

  def send_approve_message_to_admin_chat(offer)
    message = ::Benchkiller::Offers::AdminChatDecorator.decorate(offer).admin_message
    send_notification_to_chat ::BotTelegram::BenchkillerBot::ADMIN_CHAT_ID, message
  end
end
