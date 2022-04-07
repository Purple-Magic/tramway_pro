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

  def remove_place(argument)
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

  ALL_COUNTRIES.each do |(key, country)|
    define_method key do |_argument|
      current_company = company(user)
      
      country_works_states = [
        'waiting_for_add_place',
        'waiting_for_remove_place',
        'waiting_for_add_regions_to_cooperate',
        'waiting_for_remove_regions_to_cooperate',
        'waiting_for_add_regions_to_except',
        'waiting_for_remove_regions_to_except'
      ]

      return unless user.current_state(bot_record).in? country_works_states

      trim_countries = lambda do |value|
        return [] unless value.present?

        value.is_a?(Array) ? value : value&.split(',')
      end

      place_countries = trim_countries.call(current_company.place)
      regions_to_cooperate_countries = trim_countries.call(current_company.regions_to_cooperate)
      regions_to_except_countries = trim_countries.call(current_company.regions_to_except)

      data = case user.current_state(bot_record)
                  when 'waiting_for_add_place'
                    { countries: (place_countries + [country]).uniq, action: :set_place }
                  when 'waiting_for_remove_place'
                    { countries: (place_countries - [country]).uniq, action: :set_regions_to_cooperate }
                  when 'waiting_for_add_regions_to_cooperate'
                    { countries: (regions_to_cooperate_countries + [country]).uniq, action: :set_regions_to_cooperate }
                  when 'waiting_for_remove_regions_to_cooperate'
                    { countries: (regions_to_cooperate_countries - [country]).uniq, action: :set_regions_to_cooperate }
                  when 'waiting_for_add_regions_to_except'
                    { countries: (regions_to_except_countries + [country]).uniq, action: :set_regions_to_except }
                  when 'waiting_for_remove_regions_to_except'
                    { countries: (regions_to_except_countries - [country]).uniq, action: :set_regions_to_except }
                  end

      attribute = data[:action].to_s.sub('set_', '').to_sym
      answer = if current_company.update! attribute => data[:countries]
                 if data[:countries].any?
                   i18n_scope(data[:action], :success, attribute => data[:countries].join(', '))
                 else
                   i18n_scope(data[:action], :success_without_countries)
                 end
               else
                 i18n_scope(data[:action], :error)
               end

      user.set_finished_state_for bot: bot_record

      show menu: :start_menu, answer: answer
    end
  end
end
