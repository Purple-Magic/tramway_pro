require 'telegram/bot'
require_relative '../messages_manager'

module BotTelegram::Leopold::Notify
  include BotTelegram::MessagesManager

  def send_notification_to(username, message)
    bot_record = Bot.find BotTelegram::Leopold::Scenario::BOT_ID
    bot = ::Telegram::Bot::Client.new bot_record.token
    chat = BotTelegram::Chat.find_by "options ->> 'username' = '#{username}'"
    message_to_user bot.api, message, chat.telegram_chat_id
  end
end
