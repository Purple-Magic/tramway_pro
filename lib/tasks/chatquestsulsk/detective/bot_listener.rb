# frozen_string_literal: true

require 'telegram/bot'
require_relative '../../bot_telegram/info'
require_relative './scenario'

module ChatQuestUlsk::Detective
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
            ChatQuestUlsk::Detective.scenario(message, bot)
          end
        end
      end
    end
  end
end

RSM::BotListener.run_bot

require_relative '../bot_listener'
BotListener.run_bot(quest: :detective)
