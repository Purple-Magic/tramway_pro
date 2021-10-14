# frozen_string_literal: true

module BotTelegram::Benchkiller::Commands
  def start(_text)
    answer = 'Добро пожаловать! Здесь вы можете заполнить данные о своей компании.'
    inline_keyboard = [
      [
        ['Изменить название компании', { answer: 'Введите название компании:' }],
        ['Изменить адрес сайта', { answer: 'Введите ссылку на сайт:' }]
      ],
      [
        ['Изменить ссылку на портфолио', { answer: 'Введите ссылку на портфолио:' }],
        ['Изменить почту', { answer: 'Введите контактную почту:' }]
      ],
      [
        ['Изменить телефон', { answer: 'Введите контактный телефон:' }],
        ['Расположение вашей команды', { answer: 'Введите регион расположения:' }]
      ],
      [
        ['Регионы сотрудничества', { answer: 'Введите регионы для работы:' }],
        ['Посмотреть карточку компании', { answer: 'Тест' }]
      ]
    ]
    message = ::BotTelegram::Custom::Message.new text: answer, inline_keyboard: inline_keyboard

    message_to_user bot, message, chat.telegram_chat_id
  end
end
