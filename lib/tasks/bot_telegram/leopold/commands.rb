module BotTelegram
  module Leopold
    module Commands
      def add_word(text)
        words = Word.find_records_by(text, Word.active)
        if words.any?
          message_to_chat bot, chat, bot_record.options['i_have_this_word']
          message_to_chat bot, chat, build_message_with_word(words.first)
        else
          Word.create! main: text, review_state: :unviewed
          message_to_chat bot, chat, bot_record.options['we_will_review_it']
        end
      end
    end
  end
end
