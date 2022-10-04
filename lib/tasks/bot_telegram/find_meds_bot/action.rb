# frozen_string_literal: true

require 'uri'
require_relative 'tables'
require_relative 'tables/application_table'
require_relative 'tables/medicine'
require_relative 'tables/drug'
require_relative 'tables/company'
require_relative 'tables/component'
require_relative 'tables/concetration'
require_relative 'info_message_builder'

class BotTelegram::FindMedsBot::Action
  include ::BotTelegram::MessagesManager
  include ::BotTelegram::FindMedsBot
  include ::BotTelegram::FindMedsBot::Concern
  include ::BotTelegram::UsersState

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

  def find_medicine(name)
    drug = ::BotTelegram::FindMedsBot::Tables::Drug.find_by('Name' => name)
    if drug.present?
      companies = drug.medicines.map do |medicine|
        medicine.company.name
      end

      set_next_action :choose_company, medicines: drug.medicines
      answer = i18n_scope(:find_medicine, :found)
      show options: [companies, ['В начало', 'Нужной фирмы нет']], answer: answer
    else
    end
  end

  def choose_company(name)
    company = ::BotTelegram::FindMedsBot::Tables::Company.find_by('Name' => name)
    medicines = current_state.data['medicines'].select do |medicine| 
      medicine['fields']['link_to_company'].include? company.id
    end
    forms = medicines.map do |medicine|
      medicine['fields']['form']
    end.flatten.uniq

    set_next_action :choose_form, medicines: medicines
    answer = i18n_scope(:find_medicine, :what_form)
    show options: [forms, ['В начало', 'Нужной формы нет']], answer: answer
  end

  def choose_form(form)
    medicines = current_state.data['medicines'].select do |medicine| 
      medicine['fields']['form'].include? form
    end
    concentrations_ids = medicines.map do |medicine|
      medicine['fields']['concentrations']
    end.flatten.uniq

    concentrations = ::BotTelegram::FindMedsBot::Tables::Concentration.where('id' => concentrations_ids).map &:name

    set_next_action :choose_concentration, medicines: medicines
    answer = i18n_scope(:find_medicine, :what_concentration)
    show options: [concentrations, ['В начало', 'Нужной концентрации нет']], answer: answer
  end

  def choose_concentration(name)
    concentration = ::BotTelegram::FindMedsBot::Tables::Concentration.find_by('Name' => name)
    medicines = current_state.data['medicines'].select do |medicine| 
      medicine['fields']['concentrations'].include? concentration.id
    end
    if medicines.count == 1
      medicine = medicines.first
      set_next_action :reinforcement, medicine: medicine
      answer = i18n_scope(:find_medicine, :this_medicine, medicine: medicine['fields']['Name'])
      show options: [['Да', 'Нет']], answer: answer
    else
    end
  end

  private

  def send_message_to_user(text)
    message_to_chat bot.api, chat.telegram_chat_id, text
  end

  def set_next_action(action, **data)
    set_state_for "waiting_for_#{action}", user: user, bot: bot_record, data: data
  end

  def current_state
    user.states.where(bot_id: bot_record.id).last
  end
end
