# frozen_string_literal: true

require 'telegram/bot'
require_relative './bot_info'
require_relative './bot_message'
require_relative './bot_answers'
require_relative './rails_area_quest'
require_relative './after_svyaga_area_quest'

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
        message_to_user bot, 'Ты уже играешь в игру! Ответь на вопрос, который задали выше', message
      else
        choose_your_area bot, message
      end
    end
    if message.text.in? ChatQuestUlsk::Message.area.values
      if game.present?
        message_to_user bot, 'Вы уже начали игру в этом районе', message
      else
        game = ChatQuestUlsk::Game.create! bot_telegram_user_id: user.id, area: message.text, current_position: 1
      end
    end
    case game&.area
    when 'Железнодорожный'
      ChatQuestUlsk::RailsAreaQuest.scenario(message, game, user, bot)
    when 'Засвияжский'
      ChatQuestUlsk::AfterSvyagaAreaQuest.scenario(message, game, user, bot)
    end
  end
end
