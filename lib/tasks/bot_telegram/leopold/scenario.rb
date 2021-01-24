require_relative 'it_way_pro'
require_relative 'it_way_pro/words_check'

module BotTelegram
  module Leopold
    module Scenario
      class << self
        include ::BotTelegram::MessagesManager
        include ::BotTelegram::Info
        include ::BotTelegram::Leopold::ItWayPro::WordsCheck

        IT_WAY_CHAT_ID = '-434152573'

        def run(message_from_telegram, bot, bot_record, chat)
          if chat_to_answer? chat
            words = words_to_explain(message_from_telegram.text)
            words.each do |word|
              message_to_chat bot, chat, "#{word.main} - #{word.description}"
            end
          else
            message_to_chat bot, chat, bot_record.options['not_my_group']
          end
        end

        def chat_to_answer?(chat)
          chat.chat_type == 'private' || chat.telegram_id.to_s == IT_WAY_CHAT_ID.to_s
        end
      end
    end
  end
end
