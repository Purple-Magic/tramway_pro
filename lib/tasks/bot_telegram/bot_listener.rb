# frozen_string_literal: true

require 'telegram/bot'
require_relative 'scenario'

module BotTelegram
  class BotListener
    class << self
      include BotTelegram::Info
      include BotTelegram::MessagesManager

      def perform
        bot_record = Bot.find_by name: ENV['RUNNING_BOT_NAME']
        Telegram::Bot::Client.run(bot_record.token) do |bot|
          begin
            bot.listen do |message|
              user = user_from message
              chat = chat_from message
              log_message message, user, chat, bot_record
              BotTelegram::Scenario.run message, bot, bot_record
            end
          rescue Telegram::Bot::Exceptions::ResponseError => e
            Sentry.capture_exception(e)
          end
        end
      end
    end
  end
end

BotTelegram::BotListener.perform
