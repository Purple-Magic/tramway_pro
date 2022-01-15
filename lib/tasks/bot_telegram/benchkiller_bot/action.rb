# frozen_string_literal: true

require 'uri'

class BotTelegram::BenchkillerBot::Action
  include ::BotTelegram::MessagesManager
  include ::BotTelegram::BenchkillerBot
  include ::BotTelegram::BenchkillerBot::Concern

  attr_reader :message, :user, :chat, :bot, :bot_record

  def initialize(message, user, chat, bot, bot_record)
    @message = message
    @user = user
    @chat = chat
    @bot = bot
    @bot_record = bot_record
  end

  def run
    if user.current_state(bot_record).present? && current_action.present?
      if user_tapped_on_another_command_button?
        user.set_finished_state_for bot: bot_record
      else
        public_send current_action.keys.first, message.text
      end
    end
  end

  def user_tapped_on_another_command_button?
    message.is_a?(Telegram::Bot::Types::CallbackQuery)
  end

  def current_action
    BotTelegram::BenchkillerBot::ACTIONS_DATA.select do |_action_name, data|
      data[:state] == user.current_state(bot_record).to_sym
    end
  end

  def create_company
  end

  def set_company_name(company_name)
    if company_name.present?
      unless benchkiller_user(user).present?
        ::Benchkiller::User.create! bot_telegram_user_id: user.id,
          project_id: BotTelegram::BenchkillerBot::PROJECT_ID
      end
      company = benchkiller_user(user).companies.first
      if company.present?
        old_company_name = company.title
        if ::Benchkiller::Company.where(title: company_name).empty?
          company(user).update! title: company_name
          send_message_to_user i18n_scope(:set_company_name, :success, old_company_name: old_company_name, company_name: company_name)
        else
          send_message_to_user 'К сожалению, ваша компания не переименована. Обратитесь в поддержку сервиса Benchkiller'
        end
      else
        company = ::Benchkiller::Company.create! title: company_name,
          project_id: BotTelegram::BenchkillerBot::PROJECT_ID
        company.companies_users.create! user_id: benchkiller_user(user).id
        send_message_to_user "Ваша компания #{company_name} успешно создана на Benchkiller"
      end
      user.set_finished_state_for bot: bot_record
    else
      send_message_to_user 'Вам следует ввести название компании'
    end
  end

  def set_portfolio_url(portfolio_url)
    if portfolio_url.present? && portfolio_url.scan(URI::DEFAULT_PARSER.make_regexp).present?
      if portfolio_url.match? URI::DEFAULT_PARSER.make_regexp(%w[http https])
        send_message_to_user i18n_scope(:set_portfolio_url, :success, portfolio_url: portfolio_url)
      else
        send_message_to_user 'К сожалению, не удалось обновить ссылку на портфолио вашей компании. Обратитесь в поддержку сервиса Benchkiller'
        user.set_finished_state_for bot: bot_record
      end
      user.set_finished_state_for bot: bot_record
    else
      send_message_to_user 'Вам следует ввести валидную ссылку на портфолио. Ссылка должна содержать http:// или https://'
    end
  end

  def set_company_url(company_url)
    if company_url.present? && company_url.scan(URI::DEFAULT_PARSER.make_regexp).present?
      if company_url.match? URI::DEFAULT_PARSER.make_regexp(%w[http https])
        send_message_to_user i18n_scope(:set_company_url, :success, company_url: company_url)
      else
        send_message_to_user 'К сожалению, не удалось обновить ссылку на сайт вашей компании. Обратитесь в поддержку сервиса Benchkiller'
        user.set_finished_state_for bot: bot_record
      end
      user.set_finished_state_for bot: bot_record
    else
      send_message_to_user 'Вам следует ввести валидную ссылку на сайт. Ссылка должна содержать http:// или https://'
    end
  end

  def set_email(email)
    if email.present? && email.scan(URI::MailTo::EMAIL_REGEXP).present?
      send_message_to_user i18n_scope(:set_email, :success, email: email)
      user.set_finished_state_for bot: bot_record
    else
      send_message_to_user 'Вам следует ввести валидный адрес электронной почты'
    end
  end

  def set_place(place)
    if place.present?
      if company(user).update place: place
        send_message_to_user i18n_scope(:set_place, :success, place: place)
      else
        send_message_to_user 'К сожалению, не удалось обновить место расположения вашей команды. Обратитесь в поддержку сервиса Benchkiller'
        user.set_finished_state_for bot: bot_record
      end
      user.set_finished_state_for bot: bot_record
    else
      send_message_to_user 'Вам следует ввести место расположение вашей команды'
    end
  end

  def set_phone(phone)
    if phone.present?
      if company(user).update phone: phone
        send_message_to_user i18n_scope(:set_phone, :success, phone: phone)
      else
        send_message_to_user 'К сожалению, не удалось обновить контактный телефон вашей компании. Обратитесь в поддержку сервиса Benchkiller'
        user.set_finished_state_for bot: bot_record
      end
      user.set_finished_state_for bot: bot_record
    else
      send_message_to_user 'Вам следует ввести валидный контактный телефон вашей компании'
    end
  end

  def set_regions_to_cooperate(regions_to_cooperate)
    if regions_to_cooperate.present?
      if company(user).update regions_to_cooperate: regions_to_cooperate
        send_message_to_user i18n_scope(:set_regions_to_cooperate, :success, regions_to_cooperate: regions_to_cooperate)
      else
        send_message_to_user 'К сожалению, не удалось обновить Регионы сотрудничества вашей компании. Обратитесь в поддержку сервиса Benchkiller'
        user.set_finished_state_for bot: bot_record
      end
      user.set_finished_state_for bot: bot_record
    else
      send_message_to_user 'Вам следует ввести регионы сотрудничества вашей компании'
    end
  end

  private

  def send_message_to_user(text)
    message_to_chat bot.api, chat.telegram_chat_id, text
  end
end
