# frozen_string_literal: true

require 'telegram/bot'

token = '1371991341:AAHhClt1XF-OFJPQN1gIFlWUeDMHaVste-g'

def user_from(message)
  user = BotTelegram::User.find_or_create_by! username: message.from.username
  user.update! first_name: message.from.first_name,
    last_name: message.from.last_name,
    options: {
      can_join_groups: message.from.can_join_groups,
      can_read_all_group_messages: message.from.can_read_all_group_messages,
      language_code: message.from.language_code,
      supports_inline_queries: message.from.supports_inline_queries,
      is_bot: message.from.is_bot
    }
  user.reload
end

def chat_from(message)
  chat = BotTelegram::Chat.find_or_create_by! telegram_id: message.chat.id
  chat.update! title: message.chat.title,
    chat_type: message.chat.type,
    options: ([
      :all_members_are_administrators, :can_set_sticker_set, :description, :first_name, :invite_link,
      :last_name, :permissions, :photo, :pinned_message, :slow_mode_delay, :sticker_set_name,
      :username
    ].reduce({}) do |hash, attribute|
      hash.merge! attribute => message.chat.send(attribute)
    end)
  chat.reload
end

def log_message(message, user, chat)
  BotTelegram::Message.create! text: message.text, user_id: user.id, chat_id: chat.id,
    options: ([ :animation, :audio, :author_signature, :caption, :caption_entities, :channel_chat_created,
               :connected_website, :contact, :caption_entities, :channel_chat_created, :connected_website,
               :contact, :date, :delete_chat_photo, :document, :edit_date, :forward_date, :forward_from,
               :forward_from_chat, :forward_from_message_id, :forward_sender_name, :forward_signature, :game,
               :group_chat_created, :invoice, :left_chat_member, :location, :media_group_id, :message_id,
               :migrate_from_chat_id, :migrate_to_chat_id, :new_chat_members, :new_chat_photo, :new_chat_title,
               :passport_data, :photo, :pinned_message, :poll, :reply_markup, :reply_to_message, :sticker,
               :successful_payment, :supergroup_chat_created, :venue, :video, :video_note, :voice].reduce({}) do |hash, attribute|
                 hash.merge! attribute => message.send(attribute)
               end)
end

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    user = user_from message
    chat = chat_from message
    log_message message, user, chat
    case message.text
    when '/start'
      answers = Telegram::Bot::Types::ReplyKeyboardMarkup.new(
        keyboard: ['Железнодорожный'],
        one_time_keyboard: true
      )
      bot.api.send_message(
        chat_id: message.chat.id,
        text: 'Привет, выбери свой район!',
        reply_markup: answers
      )
    when 'Начать'
      answers = Telegram::Bot::Types::ReplyKeyboardMarkup.new(
        keyboard: [
          %w[Дзержинский Железнодорожный Заельцовский Калининский Кировский],
          %w[Ленинский Октябрьский Первомайский Советский Центральный]
        ],
        one_time_keyboard: true
      )
      bot.api.send_message(
        chat_id: message.chat.id,
        text: 'Выберите свой район',
        reply_markup: answers
      )
    when 'Дзержинский'
      answers = Telegram::Bot::Types::ReplyKeyboardMarkup.new(
        keyboard: [
          ['Округ 1', 'Округ 2'],
          ['Округ 3', 'Округ 4']
        ],
        one_time_keyboard: true
      )
      bot.api.send_message(
        chat_id: message.chat.id,
        text: 'Выбери округ',
        reply_markup: answers
      )
    when 'Железнодорожный'
      answers = Telegram::Bot::Types::ReplyKeyboardMarkup.new(
        keyboard: ['Округ 5', 'Округ 6'],
        one_time_keyboard: true
      )
      bot.api.send_message(
        chat_id: message.chat.id,
        text: 'Выбери округ',
        reply_markup: answers
      )
    when 'Заельцовский'
      answers = Telegram::Bot::Types::ReplyKeyboardMarkup.new(
        keyboard: [
          ['Округ 7', 'Округ 8'],
          ['Округ 9', 'Округ 10']
        ],
        one_time_keyboard: true
      )
      bot.api.send_message(
        chat_id: message.chat.id,
        text: 'Выбери округ',
        reply_markup: answers
      )
    when 'Калининский'
      answers = Telegram::Bot::Types::ReplyKeyboardMarkup.new(
        keyboard: [
          ['Округ 11', 'Округ 12'],
          ['Округ 13', 'Округ 14', 'Округ 15']
        ],
        one_time_keyboard: true
      )
      bot.api.send_message(
        chat_id: message.chat.id,
        text: 'Выбери округ',
        reply_markup: answers
      )
    when 'Кировский'
      answers = Telegram::Bot::Types::ReplyKeyboardMarkup.new(
        keyboard: [
          ['Округ 16', 'Округ 17'],
          ['Округ 18', 'Округ 19', 'Округ 20']
        ],
        one_time_keyboard: true
      )
      bot.api.send_message(
        chat_id: message.chat.id,
        text: 'Выбери округ',
        reply_markup: answers
      )
    when 'Ленинский'
      answers = Telegram::Bot::Types::ReplyKeyboardMarkup.new(
        keyboard: [
          ['Округ 21', 'Округ 22', 'Округ 23'],
          ['Округ 24', 'Округ 25', 'Округ 26', 'Округ 27']
        ],
        one_time_keyboard: true
      )
      bot.api.send_message(
        chat_id: message.chat.id,
        text: 'Выбери округ',
        reply_markup: answers
      )
    when 'Октябрьский'
      answers = Telegram::Bot::Types::ReplyKeyboardMarkup.new(
        keyboard: [
          ['Округ 28', 'Округ 29'],
          ['Округ 30', 'Округ 31', 'Округ 32']
        ],
        one_time_keyboard: true
      )
      bot.api.send_message(
        chat_id: message.chat.id,
        text: 'Выбери округ',
        reply_markup: answers
      )
    when 'Первомайский'
      answers = Telegram::Bot::Types::ReplyKeyboardMarkup.new(
        keyboard: ['Округ 33', 'Округ 34'],
        one_time_keyboard: true
      )
      bot.api.send_message(
        chat_id: message.chat.id,
        text: 'Выбери округ',
        reply_markup: answers
      )
    when 'Советский'
      answers = Telegram::Bot::Types::ReplyKeyboardMarkup.new(
        keyboard: [
          ['Округ 35', 'Округ 36'],
          ['Округ 37', 'Округ 38']
        ],
        one_time_keyboard: true
      )
      bot.api.send_message(
        chat_id: message.chat.id,
        text: 'Выбери округ',
        reply_markup: answers
      )
    when 'Центральный'
      answers = Telegram::Bot::Types::ReplyKeyboardMarkup.new(
        keyboard: ['Округ 39', 'Округ 40'],
        one_time_keyboard: true
      )
      bot.api.send_message(
        chat_id: message.chat.id,
        text: 'Выбери округ',
        reply_markup: answers
      )
    when '/stop'
      bot.api.send_message(chat_id: message.chat.id, text: "Пока, #{message.from.first_name}")
    else
      if message.text.include?('Округ')
        candidates = Elections::Candidate.where(area: message.text.split(' ')[1])
        bot.api.send_message(chat_id: message.chat.id, text: (candidates.map do |candidate|
          "#{candidate.full_name} - #{candidate.consignment}"
        end).join("\n"))
      end
    end
  end
end
