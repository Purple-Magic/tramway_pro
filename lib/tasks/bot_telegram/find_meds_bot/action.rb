# frozen_string_literal: true

require 'uri'
require_relative 'actions'
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
  include ::BotTelegram::FindMedsBot::Actions

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
