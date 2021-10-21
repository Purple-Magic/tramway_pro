# frozen_string_literal: true

require_relative '../custom/message'

module BotTelegram::BenchkillerBot::Commands
  include BotTelegram::BenchkillerBot

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


  def common_set_action(action, state, message, argument)
    BotTelegram::Users::State.create! user_id: user.id,
      bot_id: bot_record.id,
      current_state: state

    message_to_user bot, message, chat.telegram_chat_id
  end

  BotTelegram::BenchkillerBot::ACTIONS_DATA.each do |action|
    define_method(action[0]) do |argument|
      common_set_action action[0], action[1][:state], action[1][:message], argument
    end
  end

  def get_company_card(argument)
    card = ::Benchkiller::CompanyDecorator.decorate(company(user)).bot_card

    message_to_user bot, card, chat.telegram_chat_id
  end
end

