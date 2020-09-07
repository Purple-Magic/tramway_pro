# frozen_string_literal: true

require 'telegram/bot'
require_relative './bot_info'
require_relative './bot_message'
require_relative './bot_answers'
require_relative './rails_area_quest'

include ChatQuestUlsk::BotInfo
include ChatQuestUlsk::BotMessage
include ChatQuestUlsk::BotAnswers

token = ENV['CHAT_QUEST_ULSK_TELEGRAM_API_TOKEN']

def choose_your_area(bot, message)
  bot.api.send_message(
    chat_id: message.chat.id,
    text: 'Привет, выбери свой район!',
    reply_markup: Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: ChatQuestUlsk::Message.area.values, one_time_keyboard: true)
  )
end

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    user = user_from message
    chat = chat_from message
    log_message message, user, chat
    game = ChatQuestUlsk::Game.where(game_state: :started).find_by bot_telegram_user_id: user.id
    if message.text == '/start'
      if game.present?
        bot.api.send_message(
          chat_id: message.chat.id,
          text: 'Ты уже играешь в игру! Ответь на вопрос, который задали выше'
        )
      else
        choose_your_area bot, message
      end
    end
    ChatQuestUlsk::RailsAreaQuest.scenario(message, game, user, bot)
  end
end
