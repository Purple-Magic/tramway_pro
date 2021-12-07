# frozen_string_literal: true

require_relative '../custom/message'

module BotTelegram::BenchkillerBot::Commands
  include BotTelegram::BenchkillerBot

  def start(_text)
    answer = 'Добро пожаловать! Здесь вы можете заполнить данные о своей компании.'
    inline_keyboard = [
      ['Изменить название компании', { data: { command: :set_company_name } }],
      ['Изменить адрес сайта', { data: { command: :set_company_url } }],
      ['Изменить ссылку на портфолио', { data: { command: :set_portfolio_url } }],
      ['Изменить почту', { data: { command: :set_email } }],
      ['Изменить телефон', { data: { command: :set_phone } }],
      ['Расположение вашей команды', { data: { command: :set_place } }],
      ['Регионы сотрудничества', { data: { command: :set_regions_to_cooperate } }],
      ['Посмотреть карточку компании', { data: { command: :get_company_card } }],
      ['Создать пароль', { data: { command: :create_password } }]
    ]
    message = ::BotTelegram::Custom::Message.new text: answer, inline_keyboard: inline_keyboard

    message_to_user bot.api, message, chat.telegram_chat_id
  end

  def common_set_action(_action, state, message, _argument)
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

  def get_company_card(_argument)
    card = ::Benchkiller::CompanyDecorator.decorate(company(user)).bot_card

    message_to_user bot, card, chat.telegram_chat_id
  end

  def create_password(_argument)
    new_password = SecureRandom.hex(16)
    message_text = "Ваш новый пароль #{new_password}. Теперь переходите к нам на freedvs.com и вводите свой пароль."
    benchkiller_user = ::Benchkiller::User.active.find_by bot_telegram_user_id: user.id
    benchkiller_user.password = new_password
    benchkiller_user.save!

    message_to_user bot.api, message_text, chat.telegram_chat_id
  end
end
