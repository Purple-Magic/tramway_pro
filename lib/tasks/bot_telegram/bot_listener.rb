# frozen_string_literal: true

require 'telegram/bot'
require_relative '../../bot_telegram/scenario'

module ChatQuestUlsk
  module BotListener
    class << self
      include BotTelegram::Info
      include BotTelegram::MessagesManager

      def run_bot
        Telegram::Bot::Client.run(ENV["QUEST_ULSK_DETECTIVE_TELEGRAM_API_TOKEN"]) do |bot|
          bot.listen do |message|
            user = user_from message
            chat = chat_from message
            log_message message, user, chat
            BotTelegram::Scenario.run(message, bot, scenario: 'Кира', error_message: 'Ответ неверный. Ещё один шанс!')
          end
        end
      end
    end
  end
end

ChatQuestUlsk::BotListener.run_bot
