# frozen_string_literal: true

require 'telegram/bot'
require_relative 'scenario'

module BotTelegram
  class BotListener
    include BotTelegram::Info
    include BotTelegram::MessagesManager

    def perform
      bot_record = Bot.find_by name: ENV['RUNNING_BOT_NAME']
      Telegram::Bot::Client.run(bot_record.token) do |bot|
        bot.listen do |message|
          user = user_from message
          chat = chat_from message
          log_message message, user, chat
          BotTelegram::Scenario.run message, bot, bot_record
        end
      end
    end
  end
end
