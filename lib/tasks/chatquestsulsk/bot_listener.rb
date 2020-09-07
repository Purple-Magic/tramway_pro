# frozen_string_literal: true

require 'telegram/bot'
require_relative './bot_info'
require_relative './bot_message'
require_relative './bot_answers'

include ChatQuestUlsk::BotInfo
include ChatQuestUlsk::BotMessage
include ChatQuestUlsk::BotAnswers

token = ENV['CHAT_QUEST_ULSK_TELEGRAM_API_TOKEN']

start_game_message = 'Поехали!'

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    user = user_from message
    chat = chat_from message
    log_message message, user, chat
    game = ChatQuestUlsk::Game.find_by area: message.text, bot_telegram_user_id: user.id
    if message.text == '/start'
      bot.api.send_message(
        chat_id: message.chat.id,
        text: 'Привет, выбери свой район!',
        reply_markup: Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: ChatQuestUlsk::Message.area.values, one_time_keyboard: true)
      )
    elsif message.text == start_game_message
      bot.api.send_message(
        chat_id: message.chat.id,
        text: ChatQuestUlsk::Message.where(area: game&.area, position: 2).first&.text
      )
    elsif message.text.in? ChatQuestUlsk::Message.area.values
      if game.present? && game.started?
        bot.api.send_message(
          chat_id: message.chat.id,
          text: 'Вы уже начали игру в этом районе'
        )
      else
        game = ChatQuestUlsk::Game.create! bot_telegram_user_id: user.id, area: message.text, current_position: 1
        bot.api.send_message(
          chat_id: message.chat.id,
          text: ChatQuestUlsk::Message.where(area: message.text, position: 1).first&.text,
          reply_markup: Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: [start_game_message], one_time_keyboard: true) 
        )
      end
    elsif expecting_answers(game).include? message.text
      game.update! current_position: game.current_position + 1
      bot.api.send_message(
        chat_id: message.chat.id,
        text: ChatQuestUlsk::Message.where(area: game.area, position: game.current_position).first.text
      )
    else
      bot.api.send_message(
        chat_id: message.chat.id,
        text: 'Ответ неверный :( попробуй ещё раз!'
      )
    end
  end
end
