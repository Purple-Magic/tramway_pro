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
          puts "Running #{bot_record.name} bot".green
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
  end
end

BotTelegram::BotListener.run_bot
