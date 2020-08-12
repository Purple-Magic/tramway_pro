# frozen_string_literal: true

require 'telegram/bot'

token = '1372761771:AAHunTt8YA8f1P190v8TNca6txq6-b8TSnE'

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    case message.text
    when '/start'
      answers = Telegram::Bot::Types::ReplyKeyboardMarkup.new(
        keyboard: ['Начать'],
        one_time_keyboard: true
      )
      bot.api.send_message(
        chat_id: message.chat.id,
        text: 'Привет! Я бот Добрый сосед! Я помогу тебе поддержать независимых политиков в Новосибирске!',
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
