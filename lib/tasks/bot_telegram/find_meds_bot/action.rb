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

  def find_medicine(text)
    text = i18n_scope(:find_medicine, :found, name: text)
    show options: [['200', '400'], ['Другая', :start_menu]], answer: text
  end

  private

  def send_message_to_user(text)
    message_to_chat bot.api, chat.telegram_chat_id, text
  end
end
