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

      answer = i18n_scope(:find_medicine, :found)
      show options: [companies, ['В начало', 'Нужной фирмы нет']], answer: answer
    else
    end
  end

  def choose_dosage(name)
    current_dosage_id = user.states.where(bot: bot_record).last.data['dosages'][name]
    dosage = ::BotTelegram::FindMedsBot::Tables::Medicine.find current_dosage_id
    text = if dosage.separable_dosage?
           else
             alternative = ::BotTelegram::FindMedsBot::Tables::Medicine.where(
               'intersection_and_substance' => dosage['intersection_and_substance'], 'form' => dosage['form']
             ).reject do |m|
               m.id == current_dosage_id
             end.first
             company_name = BotTelegram::FindMedsBot::Tables::Company.find(alternative['company'].first)['Name']
             components = alternative['intersection_and_substance'].map do |component_id|
               BotTelegram::FindMedsBot::Tables::Concentration.find(component_id)['Name']
             end
             if alternative.present?
               BotTelegram::FindMedsBot::InfoMessageBuilder.new(alternative, company_name: company_name,
components: components).build
             end
           end
    show options: [['Назад']], answer: text
  end

  def choose_form(form)
    current_component_id = user.states.where(bot: bot_record).last.data['component_id']
    component = BotTelegram::FindMedsBot::Tables::Component.find(current_component_id)
    medicines = component.medicines_with_single_component.select do |medicine|
      medicine.form == form
    end
    answer = i18n_scope(:find_medicine, :what_concentration_do_you_need)
    show options: [medicines.map(&:concetrations), ['Другая', :start_menu]], answer: answer
    set_next_action :choose_form, component_id: component.id, dosages: dosages
  end

  private

  def send_message_to_user(text)
    message_to_chat bot.api, chat.telegram_chat_id, text
  end

  def set_next_action(action, **data)
    set_state_for "waiting_for_#{action}", user: user, bot: bot_record, data: data
  end
end
