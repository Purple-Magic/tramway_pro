# frozen_string_literal: true

require 'telegram/bot'
require_relative './bot_info'
require_relative './bot_message'
require_relative './bot_answers'
require_relative './love'
require_relative './detective'
require_relative './fantasy'


module BotListener
  class << self
    include ChatQuestUlsk::BotInfo
    include ChatQuestUlsk::BotMessage
    include ChatQuestUlsk::BotAnswers

    def run_bot(quest:)
      Telegram::Bot::Client.run(ENV["QUEST_ULSK_#{quest.upcase}_TELEGRAM_API_TOKEN"]) do |bot|
        bot.listen do |message|
          user = user_from message
          chat = chat_from message
          log_message message, user, chat
          game = ChatQuestUlsk::Game.where(game_state: :started, quest: quest).find_by bot_telegram_user_id: user.id
          if message.text == '/start'
            unless game.present?
              game = ChatQuestUlsk::Game.create! bot_telegram_user_id: user.id, quest: quest, current_position: 1 
            end
          end
          "ChatQuestUlsk::#{quest.capitalize}".constantize.scenario(message, game, user, bot)
        end
      end
    end
  end
end
