# frozen_string_literal: true

require_relative '../custom/message'

module BotTelegram::BenchkillerBot::Commands
  include BotTelegram::BenchkillerBot

  def start(_text: nil)
    answer = company(user).present? ? i18n_scope(:start, :text) : i18n_scope(:start, :new_user_text)
    menu = company(user).present? ? :start_menu : :without_company_menu
    show menu: menu, answer: answer
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

  ::BotTelegram::BenchkillerBot::MENUS.keys.each do |menu|
    define_method(menu) do |_argument|
      answer = i18n_scope(:change_company_card, :text)
      show menu: menu, answer: answer
    end
  end

  private

  def show(menu:, answer:)
    keyboard = ::BotTelegram::BenchkillerBot::MENUS[menu].map do |button_row|
      button_row.map do |button|
        ::BotTelegram::BenchkillerBot::BUTTONS[button]
      end
    end

    message = ::BotTelegram::Custom::Message.new text: answer, reply_markup: { keyboard: keyboard, one_time_keyboard: true }

    user.set_finished_state_for bot: bot_record
    message_to_user bot.api, message, chat.telegram_chat_id
  end
end
