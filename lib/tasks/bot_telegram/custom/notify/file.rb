module BotTelegram::Custom::Notify::File
  class << self
    include BotTelegram::MessagesManager

    def send_to_user(bot_id, username, file)
      bot_record = Bot.find bot_id
      bot = ::Telegram::Bot::Client.new bot_record.token
      chat = ::BotTelegram::Chat.find_by "options ->> 'username' = '#{username}'"
      bot_message = ::BotTelegram::Leopold::Message.new file
      send_file bot.api, chat.telegram_chat_id, bot_message
    end

    def send_to_chat(bot_id, chat_id, file)
      bot_record = Bot.find bot_id
      bot = ::Telegram::Bot::Client.new bot_record.token
      bot_message = ::BotTelegram::Leopold::Message.new file
      send_file bot.api, chat_id, bot_message.file
    end
  end
end
