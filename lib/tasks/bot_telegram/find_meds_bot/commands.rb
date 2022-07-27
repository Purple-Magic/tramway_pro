# frozen_string_literal: true

require_relative '../custom/message'

module BotTelegram::FindMedsBot::Commands
  include BotTelegram::FindMedsBot

  def start(_text: nil)
    answer = i18n_scope(:start, :text)
    show menu: :start_menu, answer: answer
  end

  def common_set_action(_action, state, message, _argument)
    BotTelegram::Users::State.create! user_id: user.id,
      bot_id: bot_record.id,
      current_state: state

    message_to_user bot.api, message, chat.telegram_chat_id
  end

  BotTelegram::FindMedsBot::ACTIONS_DATA.each do |action|
    define_method(action[0]) do |argument|
      get_company_card nil
      common_set_action action[0], action[1][:state], action[1][:message], argument
    end
  end

  def set_place(_argument)
    answer = i18n_scope :set_place, :text
    show menu: :set_place_menu, answer: answer, continue_action: true
  end

  def set_regions_to_cooperate(_argument)
    answer = i18n_scope :set_regions_to_cooperate, :text
    show menu: :set_regions_to_cooperate_menu, answer: answer, continue_action: true
  end

  def set_regions_to_except(_argument)
    answer = i18n_scope :set_regions_to_except, :text
    show menu: :set_regions_to_except_menu, answer: answer, continue_action: true
  end

  def add_place(_argument)
    BotTelegram::Users::State.create! user_id: user.id,
      bot_id: bot_record.id,
      current_state: :waiting_for_add_place

    answer = i18n_scope :add_place, :text
    show menu: :add_place_menu, answer: answer
  end

  def remove_place(argument)
    BotTelegram::Users::State.create! user_id: user.id,
      bot_id: bot_record.id,
      current_state: :waiting_for_remove_place

    answer = i18n_scope :remove_place, :text

    countries = company(user).place
    unless countries.present?
      user.set_finished_state_for bot: bot_record
      answer = i18n_scope :set_place, :no_countries_to_delete
      show menu: :start_menu, answer: answer
      return
    end

    options = ALL_COUNTRIES.map do |(key, country)|
      key if countries.include? country
    end.compact

    show options: [options], answer: answer
  end

  def add_region_to_cooperate(_argument)
    BotTelegram::Users::State.create! user_id: user.id,
      bot_id: bot_record.id,
      current_state: :waiting_for_add_regions_to_cooperate

    answer = i18n_scope :add_region_to_cooperate, :text
    show menu: :add_region_to_cooperate_menu, answer: answer
  end

  def remove_region_to_cooperate(argument)
    BotTelegram::Users::State.create! user_id: user.id,
      bot_id: bot_record.id,
      current_state: :waiting_for_remove_regions_to_cooperate

    answer = i18n_scope :remove_region_to_cooperate, :text

    countries = company(user).regions_to_cooperate
    unless countries.present?
      user.set_finished_state_for bot: bot_record
      answer = i18n_scope :set_regions_to_cooperate_menu, :no_countries_to_delete
      show menu: :start_menu, answer: answer
      return
    end

    options = ALL_COUNTRIES.map do |(key, country)|
      key if countries.include? country
    end.compact

    show options: [options], answer: answer
  end

  def add_region_to_except(_argument)
    BotTelegram::Users::State.create! user_id: user.id,
      bot_id: bot_record.id,
      current_state: :waiting_for_add_regions_to_except

    answer = i18n_scope :add_region_to_except, :text
    show menu: :add_region_to_except_menu, answer: answer
  end

  def remove_region_to_except(argument)
    BotTelegram::Users::State.create! user_id: user.id,
      bot_id: bot_record.id,
      current_state: :waiting_for_remove_regions_to_except

    answer = i18n_scope :remove_region_to_except, :text

    countries = company(user).regions_to_except
    unless countries.present?
      user.set_finished_state_for bot: bot_record
      answer = i18n_scope :set_regions_to_except, :no_countries_to_delete
      show menu: :start_menu, answer: answer
      return
    end

    options = ALL_COUNTRIES.map do |(key, country)|
      key if countries.include? country
    end.compact

    show options: [options], answer: answer
  end

  def create_company(_argument)
    BotTelegram::Users::State.create! user_id: user.id,
      bot_id: bot_record.id,
      current_state: ::BotTelegram::FindMedsBot::ACTIONS_DATA[:create_company][:state]

    message_to_user(
      bot.api,
      ::BotTelegram::FindMedsBot::ACTIONS_DATA[:create_company][:message],
      chat.telegram_chat_id
    )
  end

  def get_company_card(_argument)
    return unless company(user).present?

    card = ::FindMeds::CompanyDecorator.decorate(company(user)).bot_card

    message_to_user bot.api, card, chat.telegram_chat_id
  end

  def create_password(_argument)
    new_password = SecureRandom.hex(16)
    message_text = "Ваш новый пароль #{new_password}. Теперь переходите к нам на freedvs.com и вводите свой пароль."
    benchkiller_user = ::FindMeds::User.find_by bot_telegram_user_id: user.id
    benchkiller_user.password = new_password
    begin
      benchkiller_user.save!
    rescue StandardError => error
      Rails.env.development? ? puts(error) : Airbrake.notify(error)
    end

    message_to_user bot.api, message_text, chat.telegram_chat_id
  end

  def manage_subscription(_argument); end

  ::BotTelegram::FindMedsBot::MENUS.each_key do |menu|
    define_method(menu) do |_argument|
      answer = i18n_scope(menu, :text)
      show menu: menu, answer: answer
    end
  end
end
