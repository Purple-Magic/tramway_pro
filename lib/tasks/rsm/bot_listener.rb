# frozen_string_literal: true

require 'telegram/bot'
require_relative '../bot_telegram/scenario'

module RSM
  module BotListener
    class << self
      include BotTelegram::Info
      include BotTelegram::MessagesManager

      def run_bot
        Telegram::Bot::Client.run(ENV["RSM_PROJECT_TELEGRAM_API_TOKEN"]) do |bot|
          bot.listen do |message|
            user = user_from message
            chat = chat_from message
            log_message message, user, chat
            BotTelegram::Scenario.run(message, bot, scenario: 'Проектный офис РСМ', error_message: 'Используйте встроенную клавиатуру, пожалуйста')
          end
        end
      end
    end
  end
end

RSM::BotListener.run_bot

