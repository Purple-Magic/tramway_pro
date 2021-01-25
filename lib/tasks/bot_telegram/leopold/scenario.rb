require_relative 'it_way_pro'
require_relative 'it_way_pro/words_check'
require_relative 'commands'

module BotTelegram
  module Leopold
    class Scenario
      include ::BotTelegram::MessagesManager
      include ::BotTelegram::Info
      include ::BotTelegram::Leopold::ItWayPro::WordsCheck
      include ::BotTelegram::Leopold::Commands

      IT_WAY_CHAT_ID = '-1001141858122'
      COMMANDS = ['add_word']

      attr_reader :bot
      attr_reader :bot_record
      attr_reader :chat
      attr_reader :message_from_telegram

      def initialize(message_from_telegram, bot, bot_record, chat)
        @bot = bot
        @message_from_telegram = message_from_telegram
        @bot_record = bot_record
        @chat = chat
      end

      def run
        if chat_to_answer? chat
          command = get_command message_from_telegram.text
          if command.present?
            send command, message_from_telegram.text.gsub(/^\/#{command} /, '').gsub(/^\@myleopold_bot/, '')
          else
            words = words_to_explain(message_from_telegram.text)
            words.each do |word|
              message_to_chat bot, chat, build_message_with_word(word)
              if private_chat? chat
                message_to_chat bot, chat, bot_record.options['you_can_add_words']
              end
            end
          end
        else
          #message_to_chat bot, chat, bot_record.options['not_my_group']
        end
      end

      def chat_to_answer?(chat)
        #private_chat?(chat) || chat.telegram_chat_id.to_s == IT_WAY_CHAT_ID.to_s
        true
      end

      def private_chat?(chat)
        chat.chat_type == 'private' 
      end

      def get_command(text)
        COMMANDS.reduce('') do |method_name, command|
          method_name = command if text&.match?(/^\/#{command}/)
        end
      end

      def build_message_with_word(word)
        "#{word.main} - #{word.description}"
      end

      def bot
        @bot
      end

      def bot_record
        @bot_record
      end

      def message_from_telegram
        @message_from_telegram
      end

      def chat
        @chat
      end
    end
  end
end
