# frozen_string_literal: true

require 'telegram/bot'
require_relative './bot_info'
require_relative './bot_message'
require_relative './bot_answers'
require_relative './love'
require_relative './after_svyaga_area_quest'

include ChatQuestUlsk::BotInfo
include ChatQuestUlsk::BotMessage
include ChatQuestUlsk::BotAnswers

quests = [:love]

quests.each do |quest|
  Telegram::Bot::Client.run(ENV["QUEST_ULSK_#{quest.upcase}_TELEGRAM_API_TOKEN"]) do |bot|
    bot.listen do |message|
      user = user_from message
      chat = chat_from message
      log_message message, user, chat
      game = ChatQuestUlsk::Game.where(game_state: :started, quest: :love).find_by bot_telegram_user_id: user.id
      if message.text == '/start'
        unless game.present?
          game = ChatQuestUlsk::Game.create! bot_telegram_user_id: user.id, quest: :love, current_position: 1
        end
      end
      ChatQuestUlsk::Love.scenario(message, game, user, bot)
    end
  end
end
