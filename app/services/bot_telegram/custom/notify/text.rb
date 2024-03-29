# frozen_string_literal: true

module BotTelegram::Custom::Notify::Text
  class << self
    include BotTelegram::MessagesManager

    def send_to_user(bot_id, username, message)
      bot_record = Bot.find bot_id
      bot = ::Telegram::Bot::Client.new bot_record.token
      chat = BotTelegram::Chat.where(bot_id: bot_id).find_by "options ->> 'username' = '#{username}'"
      message_to_user bot.api, message, chat.telegram_chat_id if chat.present?
    end

    def send_to_chat(bot_id, chat_id, message, **options)
      bot_record = Bot.find bot_id
      bot = ::Telegram::Bot::Client.new bot_record.token
      message_to_chat bot.api, chat_id, message, **options
    end

    def send_to_channel(bot_id, channel_id, message)
      bot_record = Bot.find bot_id
      bot = ::Telegram::Bot::Client.new bot_record.token
      message_to_user bot.api, message, channel_id
    end
  end
end
