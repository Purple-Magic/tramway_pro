# frozen_string_literal: true

require_relative '../custom/notify/file'
require_relative '../custom/notify/text'

module BotTelegram::FindMedsBot::Notify
  # :reek:UtilityFunction { enabled: false }
  def send_notification_to_user(username, message)
    ::BotTelegram::Custom::Notify::Text.send_to_user BotTelegram::FindMedsBot.bot_id, username, message
  end
  # :reek:UtilityFunction { enabled: true }

  # :reek:UtilityFunction { enabled: false }
  def send_notification_to_chat(chat_id, message, **options)
    ::BotTelegram::Custom::Notify::Text.send_to_chat BotTelegram::FindMedsBot.bot_id, chat_id, message, **options
  end
  # :reek:UtilityFunction { enabled: true }

  # :reek:UtilityFunction { enabled: false }
  def send_notification_to_channel(channel_id, message)
    ::BotTelegram::Custom::Notify::Text.send_to_channel BotTelegram::FindMedsBot.bot_id, channel_id, message
  end
  # :reek:UtilityFunction { enabled: true }

  # :reek:UtilityFunction { enabled: false }
  def send_file_to_user(username, file)
    ::BotTelegram::Custom::Notify::File.send_to_user BotTelegram::FindMedsBot.bot_id, username, file
  end
  # :reek:UtilityFunction { enabled: true }

  # :reek:UtilityFunction { enabled: false }
  def send_file_to_chat(chat_id, file)
    ::BotTelegram::Custom::Notify::File.send_to_chat BotTelegram::FindMedsBot.bot_id, chat_id, file
  end
  # :reek:UtilityFunction { enabled: true }
end
