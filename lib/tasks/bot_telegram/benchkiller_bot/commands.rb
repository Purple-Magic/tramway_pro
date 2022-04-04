# frozen_string_literal: true

require_relative '../custom/message'
require_relative 'countries_helper'

module BotTelegram::BenchkillerBot::Commands
  include BotTelegram::BenchkillerBot
  include BotTelegram::BenchkillerBot::CountriesHelper

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

  def set_place(_argument)
    BotTelegram::Users::State.create! user_id: user.id,
      bot_id: bot_record.id,
      current_state: :waiting_for_set_place

    answer = i18n_scope :set_place, :text
    show menu: :set_place_menu, answer: answer, continue_action: true
  end

  def add_place(_argument)
    answer = i18n_scope :add_place, :text
    show menu: :add_place_menu, answer: answer
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

  def manage_subscription(_argument); end

  ::BotTelegram::BenchkillerBot::MENUS.each_key do |menu|
    define_method(menu) do |_argument|
      answer = i18n_scope(menu, :text)
      show menu: menu, answer: answer
    end
  end

  MAIN_COUNTRIES.merge(EUROPA_COUNTRIES).merge(ASIA_COUNTRIES).merge(AMERICA_COUNTRIES).merge(WHOLE_COUNTRIES).each do |(key, country)|
    define_method key do |_argument|
      current_company = company(user)
      case user.current_state(bot_record)
      when 'waiting_for_set_place'
        countries = ((current_company.place&.split(',') || []) + [country]).uniq
        if current_company.update! place: countries
          message_to_user bot.api, i18n_scope(:set_place, :success, place: countries.join(', ')), chat.telegram_chat_id
        else
          message_to_user bot.api, i18n_scope(:set_place, :error), chat.telegram_chat_id
        end
      end
    end
  end
end
