# frozen_string_literal: true

require_relative '../custom/notify/file'
require_relative '../custom/notify/text'

module BotTelegram::FindMedsBot::Notify
  def send_notification_to_user(username, message)
    ::BotTelegram::Custom::Notify::Text.send_to_user BotTelegram::FindMedsBot.bot_id, username, message
  end

  def send_notification_to_chat(chat_id, message, **options)
    ::BotTelegram::Custom::Notify::Text.send_to_chat BotTelegram::FindMedsBot.bot_id, chat_id, message, **options
  end

  def send_notification_to_channel(channel_id, message)
    ::BotTelegram::Custom::Notify::Text.send_to_channel BotTelegram::FindMedsBot.bot_id, channel_id, message
  end

  def send_file_to_user(username, file)
    ::BotTelegram::Custom::Notify::File.send_to_user BotTelegram::FindMedsBot.bot_id, username, file
  end

  def send_file_to_chat(chat_id, file)
    ::BotTelegram::Custom::Notify::File.send_to_chat BotTelegram::FindMedsBot.bot_id, chat_id, file
  end
end
