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
      end.uniq

      set_next_action :choose_company, medicines: drug.medicines
      answer = i18n_scope(:find_medicine, :found)
      show options: [companies, ['В начало', 'Нужного производителя нет']], answer: answer
    else
      set_next_action :saving_feedback, medicine_name: name
      answer = i18n_scope(:find_medicine, :not_found)
      show options: [['В начало']], answer: answer
    end
  end

  def choose_company(name)
    if name == 'Нужного производителя нет'
      set_next_action :saving_feedback
      answer = i18n_scope(:find_medicine, :company_not_found)
      show options: [['В начало']], answer: answer
    else
      company = ::BotTelegram::FindMedsBot::Tables::Company.find_by('Name' => name)
      medicines = current_state.data['medicines'].select do |medicine|
        medicine['fields']['link_to_company'].include? company.id
      end
      forms = medicines.map do |medicine|
        medicine['fields']['form']
      end.flatten.uniq

      if forms.any?
        set_next_action :choose_form, medicines: medicines
        answer = i18n_scope(:find_medicine, :what_form)
        show options: [forms, ['В начало', 'Нужной формы нет']], answer: answer
      else
        set_next_action :saving_feedback
        answer = i18n_scope(:find_medicine, :we_dont_have_forms)
        show options: [['В начало']], answer: answer
      end
    end
  end

  def choose_form(form)
    if form == 'Нужной формы нет'
      set_next_action :saving_feedback
      answer = i18n_scope(:find_medicine, :form_not_found)
      show options: [['В начало']], answer: answer
    else
      medicines = current_state.data['medicines'].select do |medicine|
        medicine['fields']['form'].include? form
      end
      concentrations_ids = medicines.map do |medicine|
        medicine['fields']['concentrations']
      end.flatten.uniq

      concentrations = ::BotTelegram::FindMedsBot::Tables::Concentration.where('id' => concentrations_ids)
      components = ::BotTelegram::FindMedsBot::Tables::Component.where('id' => concentrations.map(&:link_to_active_components).flatten)

      if components.count > 1
        set_next_action :saving_feedback
        answer = 'У этого лекарства более одного действующего вещества, пока что бот не умеет работать с такими лекарствами. Напишите комментарий в свободной форме, что вы хотели найти.'
        show options: [['В начало']], answer: answer
      elsif components.count == 1
        set_next_action :choose_concentration, medicines: medicines, concentrations: concentrations
        answer = i18n_scope(:find_medicine, :what_concentration, component: components.first.name)
        buttons_collection = concentrations.each_slice(4).map do |concentration|
          concentration.map(&:value)
        end
        show options: [*buttons_collection, ['В начало', 'Нужной концентрации нет']], answer: answer
      elsif components.count.zero?
        send_message_to_user 'Кажется, у нас ошибка в базе данных'
      end
    end
  end

  def choose_concentration(value)
    if value == 'Нужной концентрации нет'
      set_next_action :saving_feedback
      answer = i18n_scope(:find_medicine, :concentration_not_found)
      show options: [['В начало']], answer: answer
    else
      concentrations_ids = current_state.data['concentrations'].map { |c| c['id'] }
      concentrations = ::BotTelegram::FindMedsBot::Tables::Concentration.where('id' => concentrations_ids)
      concentration = concentrations.select do |concentration|
        concentration.value == value
      end.first
      medicines = current_state.data['medicines'].select do |medicine|
        medicine['fields']['concentrations'].include? concentration.id
      end
      if medicines.count == 1
        medicine = medicines.first
        set_next_action :reinforcement, medicine: medicine
        answer = i18n_scope(:find_medicine, :this_medicine, medicine: medicine['fields']['Name'])
        show options: [%w[Да Нет]], answer: answer
      end
    end
  end

  def reinforcement(answer)
    case answer
    when 'Да'
      medicine = current_state.data['medicine']
      medicines = ::BotTelegram::FindMedsBot::Tables::Medicine.where(
        'concentrations' => medicine['fields']['concentrations'],
        'form' => medicine['fields']['form']
      )
      set_next_action :last_step
      list = medicines.map do |medicine|
        "🔵 #{medicine.name}"
      end.join("\n")
      answer = i18n_scope(:find_medicine, :result_message, list: list)
      show options: [['Бот мне помог!'], ['Это не совсем та информация, на которую я надеялся_ась (отправить отзыв)']],
        answer: answer
    when 'Нет'
      set_next_action :saving_feedback
      answer = i18n_scope(:find_medicine, :unfortunately_we_do_not_have_more_info)
      show options: [['В начало']], answer: answer
    end
  end

  def last_step(answer)
    case answer
    when 'Бот мне помог!'
      user.set_finished_state_for bot: bot_record
      answer = i18n_scope(:find_medicine, :congratulations)
      show options: [['В начало']], answer: answer
    when 'Это не совсем та информация, на которую я надеялся_ась (отправить отзыв)'
      set_next_action :saving_feedback
      answer = i18n_scope(:find_medicine, :please_type_info_about_medicine)
      show options: [['В начало']], answer: answer
    end
  end

  def saving_feedback(text)
    feedback = FindMeds::FeedbackForm.new FindMeds::Feedback.new
    data_of_conversation = user.current_conversation.map { |state| state['data'] }
    if feedback.submit text: text, data: data_of_conversation
      answer = i18n_scope(:find_medicine, :we_got_it)
      show options: [['В начало']], answer: answer
    else
      send_message_to_user 'Что-то пошло не так'
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
