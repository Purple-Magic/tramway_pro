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
    return unless user.current_state(bot_record).present? && current_action.present?

    if user_tapped_on_another_command_button?
      user.set_finished_state_for bot: bot_record
    else
      public_send current_action.keys.first, message.text
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

  def company
    benchkiller_user(user).companies.first
  end

  def create_company(title)
    unless benchkiller_user(user).present?
      ::Benchkiller::User.create! bot_telegram_user_id: user.id,
        project_id: BotTelegram::BenchkillerBot::PROJECT_ID,
        password: SecureRandom.hex(16)
    end

    company = ::Benchkiller::Company.new title: title,
      project_id: BotTelegram::BenchkillerBot::PROJECT_ID
    if company.save
      company.companies_users.create! user_id: benchkiller_user(user).id
      user.set_finished_state_for bot: bot_record
      show menu: :change_company_card, answer: i18n_scope(:create_company, :success, title: title)
    else
      send_message_to_user company.errors.full_messages.first
    end
  end

  # rubocop:disable Naming/AccessorMethodName
  def set_company_name(company_name)
    if company_name.present? && company.present?
      old_company_name = company.title
      if ::Benchkiller::Company.where(title: company_name).empty?
        company.update! title: company_name
        send_message_to_user i18n_scope(
          :set_company_name,
          :success,
          old_company_name: old_company_name,
          company_name: company_name
        )
      else
        send_message_to_user i18n_scope :set_company_name, :failure
      end
      user.set_finished_state_for bot: bot_record
    else
      send_message_to_user i18n_scope :set_company_name, :error
    end
  end
  # rubocop:enable Naming/AccessorMethodName

  validations = {
    url: lambda do |value|
      value.present? && value.match?(URI::DEFAULT_PARSER.make_regexp(%w[http https]))
    end,
    just_text: ->(value) { value.present? }
  }

  attributes_data = [
    { name: :portfolio_url, validation: validations[:url] },
    { name: :company_url, validation: validations[:url] },
    { name: :place, validation: validations[:just_text] },
    { name: :phone, validation: validations[:just_text] },
    { name: :regions_to_cooperate, validation: validations[:just_text] },
    {
      name: :email,
      validation: lambda do |value|
        value.present? && value.scan(URI::MailTo::EMAIL_REGEXP).present?
      end
    }
  ]

  attributes_data.each do |data|
    command_name = "set_#{data[:name]}"
    define_method command_name do |value|
      if data[:validation].call(value)
        if company.update data[:name] => value
          send_message_to_user i18n_scope(command_name, :success, data[:name] => value)
        else
          send_message_to_user i18n_scope command_name, :error
        end
        user.set_finished_state_for bot: bot_record
      else
        send_message_to_user i18n_scope command_name, :failure
      end
    end
  end

  private

  def send_message_to_user(text)
    message_to_chat bot.api, chat.telegram_chat_id, text
  end
end
