# frozen_string_literal: true

require 'uri'

class BotTelegram::FindMedsBot::Action
  include ::BotTelegram::MessagesManager
  include ::BotTelegram::FindMedsBot
  include ::BotTelegram::FindMedsBot::Concern

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
    BotTelegram::FindMedsBot::ACTIONS_DATA.select do |_action_name, data|
      data[:state] == user.current_state(bot_record).to_sym
    end
  end

  def company
    benchkiller_user(user).companies.first
  end

  def create_company(title)
    unless benchkiller_user(user).present?
      ::FindMeds::User.create! bot_telegram_user_id: user.id,
        project_id: BotTelegram::FindMedsBot::PROJECT_ID,
        password: SecureRandom.hex(16)
    end

    company = ::FindMeds::Company.new title: title,
      project_id: BotTelegram::FindMedsBot::PROJECT_ID
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
      if ::FindMeds::Company.where(title: company_name).empty?
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

  BotTelegram::FindMedsBot::ATTRIBUTES_DATA.each do |data|
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
