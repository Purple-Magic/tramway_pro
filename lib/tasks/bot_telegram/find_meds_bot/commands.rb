# frozen_string_literal: true

require_relative '../custom/message'

module BotTelegram::FindMedsBot::Commands
  include BotTelegram::FindMedsBot
  include BotTelegram::UsersState

  def start(_text: nil)
    user.set_finished_state_for bot: bot_record
    answer = i18n_scope(:start, :text)
    show menu: :start_menu, answer: answer
  end

  def common_action(_action, state, message, _argument)
    set_state_for state, user: user, bot: bot_record
    message_to_user bot.api, message, chat.telegram_chat_id
  end

  BotTelegram::FindMedsBot::ACTIONS_DATA.each do |action|
    define_method(action[0]) do |argument|
      common_action action[0], action[1][:state], action[1][:message], argument
    end
  end

  ::BotTelegram::FindMedsBot::MENUS.each_key do |menu|
    define_method(menu) do |_argument|
      answer = i18n_scope(menu, :text)
      show menu: menu, answer: answer
    end
  end
end
