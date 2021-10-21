# frozen_string_literal: true

module BotTelegram::Benchkiller::Commands
  def start(_text)
    answer = 'Добро пожаловать! Здесь вы можете заполнить данные о своей компании.'
    inline_keyboard = [
      [
        ['Изменить название компании', { data: { command: :set_company_name } }],
        ['Изменить адрес сайта', { data: { command: :set_company_url } }]
      ],
      [
        ['Изменить ссылку на портфолио', { data: { command: :set_portfolio_url } }],
        ['Изменить почту', { data: { command: :set_email } }]
      ],
      [
        ['Изменить телефон', { data: { command: :set_phone } }],
        ['Расположение вашей команды', { data: { command: :set_place } }]
      ],
      [
        ['Регионы сотрудничества', { data: { command: :set_regions_to_cooperate } }],
        ['Посмотреть карточку компании', { data: { command: :get_company_card } }]
      ]
    ]
    message = ::BotTelegram::Custom::Message.new text: answer, inline_keyboard: inline_keyboard

    message_to_user bot, message, chat.telegram_chat_id
  end

  def set_company_name(argument)
    message = 'Введите название компании'

    message_to_user bot, message, chat.telegram_chat_id
  end

  def set_portfolio_url(argument)
  end

  def set_company_url(argument)
  end

  def set_email(argument)
  end
  
  def set_place(argument)
  end

  def set_phone(argument)
  end

  def set_regions_to_cooperate(argument)
  end

  def get_company_card(argument)
  end
end

