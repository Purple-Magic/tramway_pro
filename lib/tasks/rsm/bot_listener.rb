# frozen_string_literal: true

require 'telegram/bot'
require_relative './../bot_telegram/info'
require_relative './../bot_telegram/message_builder'
require_relative './project_office'

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
            RSM::ProjectOffice.scenario(message, bot)
          end
        end
      end
    end
  end
end

RSM::BotListener.run_bot
