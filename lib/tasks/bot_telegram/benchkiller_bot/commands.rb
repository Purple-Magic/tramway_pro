# frozen_string_literal: true

module BotTelegram::BenchkillerBot::Commands
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

  SET_ACTIONS_DATA = {
    set_company_name: {
      message: 'Введите название компании',
      state: :waiting_for_set_company_name
    },
    set_portfolio_url: {
      message: 'Введите ссылку на портфолио',
      state: :waiting_for_set_portfolio_url
    },
    set_company_url: {
      message: 'Введите адрес сайта компании',
      state: :waiting_for_set_company_url
    },
    set_email: {
      message: 'Введите контактный email',
      state: :waiting_for_set_email
    },
    set_place: {
      message: 'Введите расположение вашей команды',
      state: :waiting_for_set_place
    },
    set_phone: {
      message: 'Введите контактный телефон',
      state: :waiting_for_set_phone
    },
    set_regions_to_cooperate: {
      message: 'Введите регионы сотрудничества',
      state: :waiting_for_set_regions_to_cooperate
    }
  }

  def common_set_action(action, argument)
    message = SET_ACTIONS_DATA[action][:message]

    BotTelegram::Users::State.create! user_id: user.id,
      bot_id: bot_record.id,
      current_state: SET_ACTIONS_DATA[action][:state]

    message_to_user bot, message, chat.telegram_chat_id
  end

  ::BotTelegram::BenchkillerBot::Action::STATES_ACTIONS_RELATION.values.each do |action|
    define_method(action) do |argument|
      common_set_action action, argument
    end
  end

  def get_company_card(argument)
  end
end

