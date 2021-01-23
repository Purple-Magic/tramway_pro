module BotTelegram
  module Leopold
    module Scenario
      class << self
        include ::BotTelegram::MessagesManager
        include ::BotTelegram::Info
        include ::BotTelegram::Leopold::ItWay::WordsCheck

        IT_WAY_CHAT_ID = '-434152573'

        def run(message_from_telegram, bot, bot_record, chat)
          if chat.telegram_id.to_s == IT_WAY_CHAT_ID.to_s
            words = words_to_explain(message_from_telegram.text)
            words.each do |word|
              message_to_chat bot, chat, "#{word.main} - #{word.description}"
            end
          end
        end
      end
    end
  end
end
