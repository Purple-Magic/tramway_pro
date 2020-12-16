# frozen_string_literal: true

require 'telegram/bot'
require_relative 'scenario'

module BotTelegram
  module BotListener
    class << self
      include BotTelegram::Info
      include BotTelegram::MessagesManager

      def run_bot
        Bot.active.find_each do |bot_record|
          Telegram::Bot::Client.run(bot_record.token) do |bot|
            bot.listen do |message|
              user = user_from message
              chat = chat_from message
              log_message message, user, chat
              BotTelegram::Scenario.run(message, bot, scenario: bot_record.title, error_message: 'Используйте встроенную клавиатуру, пожалуйста')
            end
          end
        end
      end
    end
  end
end

RSM::BotListener.run_bot

