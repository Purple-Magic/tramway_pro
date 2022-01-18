# frozen_string_literal: true

require_relative '../custom/message'

module BotTelegram::BenchkillerBot::Commands
  include BotTelegram::BenchkillerBot

  def start(_text: nil)
    answer = company(user).present? ? i18n_scope(:start, :text) : i18n_scope(:start, :new_user_text)
    inline_keyboard = if company(user).present?
                        [
                          ['Изменить название компании', { data: { command: :set_company_name } }],
                          ['Изменить адрес сайта', { data: { command: :set_company_url } }],
                          ['Изменить ссылку на портфолио', { data: { command: :set_portfolio_url } }],
                          ['Изменить почту', { data: { command: :set_email } }],
                          ['Изменить телефон', { data: { command: :set_phone } }],
                          ['Расположение вашей команды', { data: { command: :set_place } }],
                          ['Регионы сотрудничества', { data: { command: :set_regions_to_cooperate } }],
                          ['Посмотреть карточку компании', { data: { command: :get_company_card } }]
                          # ['Создать пароль', { data: { command: :create_password } }]
                        ]
                      else
                        [
                          ['Создать компанию', { data: { command: :create_company } }]
                        ]
                      end

    message = ::BotTelegram::Custom::Message.new text: answer, inline_keyboard: inline_keyboard

    user.set_finished_state_for bot: bot_record
    message_to_user bot.api, message, chat.telegram_chat_id
  end

  def common_set_action(_action, state, message, _argument)
    BotTelegram::Users::State.create! user_id: user.id,
      bot_id: bot_record.id,
      current_state: state

    message_to_user bot.api, message, chat.telegram_chat_id
  end

  BotTelegram::BenchkillerBot::ACTIONS_DATA.each do |action|
    define_method(action[0]) do |argument|
      get_company_card nil
      common_set_action action[0], action[1][:state], action[1][:message], argument
    end
  end

  def create_company(_argument)
    BotTelegram::Users::State.create! user_id: user.id,
      bot_id: bot_record.id,
      current_state: ::BotTelegram::BenchkillerBot::ACTIONS_DATA[:create_company][:state]

    message_to_user(
      bot.api,
      ::BotTelegram::BenchkillerBot::ACTIONS_DATA[:create_company][:message],
      chat.telegram_chat_id
    )
  end

  def get_company_card(_argument)
    return unless company(user).present?

    card = ::Benchkiller::CompanyDecorator.decorate(company(user)).bot_card

    message_to_user bot.api, card, chat.telegram_chat_id
  end

  def create_password(_argument)
    new_password = SecureRandom.hex(16)
    message_text = "Ваш новый пароль #{new_password}. Теперь переходите к нам на freedvs.com и вводите свой пароль."
    benchkiller_user = ::Benchkiller::User.find_by bot_telegram_user_id: user.id
    benchkiller_user.password = new_password
    begin
      benchkiller_user.save!
    rescue StandardError => error
      Rails.env.development? ? puts(error) : Airbrake.notify(error)
    end

    message_to_user bot.api, message_text, chat.telegram_chat_id
  end
end
