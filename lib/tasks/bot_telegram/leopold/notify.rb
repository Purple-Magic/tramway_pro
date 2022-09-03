# frozen_string_literal: true

require_relative '../custom/notify/file'
require_relative '../custom/notify/text'

module BotTelegram::Leopold::Notify
  def send_notification_to_user(username, message)
    ::BotTelegram::Custom::Notify::Text.send_to_user BotTelegram::Leopold::Scenario::BOT_ID, username, message
  end

  def send_notification_to_chat(chat_id, message)
    ::BotTelegram::Custom::Notify::Text.send_to_chat BotTelegram::Leopold::Scenario::BOT_ID, chat_id, message
  end

  def send_file_to_user(username, file)
    ::BotTelegram::Custom::Notify::File.send_to_user BotTelegram::Leopold::Scenario::BOT_ID, username, file
  end

  def send_file_to_chat(chat_id, file, **options)
    ::BotTelegram::Custom::Notify::File.send_to_chat BotTelegram::Leopold::Scenario::BOT_ID, chat_id, file, **options
  end
end
