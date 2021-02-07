# frozen_string_literal: true

require_relative 'it_way_pro'
require_relative 'it_way_pro/words_check'
require_relative 'commands'

module BotTelegram::Leopold
  class Scenario
    include ::BotTelegram::MessagesManager
    include ::BotTelegram::Info
    include ::BotTelegram::Leopold::ItWayPro::WordsCheck
    include ::BotTelegram::Leopold::Commands

    IT_WAY_CHAT_ID = '-1001141858122'
    COMMANDS = ['add_word'].freeze

    attr_reader :bot, :bot_record, :chat, :message_from_telegram, :bot, :bot_record, :message_from_telegram, :chat

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
          send command, message_from_telegram.text.gsub(%r{^/#{command} }, '').gsub(/^@myleopold_bot/, '')
        else
          words = words_to_explain(message_from_telegram.text)
          if words.class.to_s == 'Word'
            unless sended_recently? words
              send_word words
              message_to_chat bot, chat, bot_record.options['you_can_add_words'] if private_chat? chat
            end
          else
            words&.each do |word|
              unless sended_recently? word
                send_word word
                message_to_chat bot, chat, bot_record.options['you_can_add_words'] if private_chat? chat
              end
            end
          end
        end
      else
        message_to_chat bot, chat, bot_record.options['not_my_group']
      end
    end

    def chat_to_answer?(chat)
      private_chat?(chat) || chat.telegram_chat_id.to_s == IT_WAY_CHAT_ID.to_s
    end

    def private_chat?(chat)
      chat.chat_type == 'private'
    end

    def get_command(text)
      COMMANDS.reduce('') do |_method_name, command|
        method_name = command if text&.match?(%r{^/#{command}})
      end
    end

    def send_word(word)
      message_to_chat bot, chat, build_message_with_word(word)
      ::ItWay::WordUse.create! word_id: word.id, chat_id: chat.id
    end

    def sended_recently?(word)
      last_use = ::ItWay::WordUse.where(word_id: word.id, chat_id: chat.id).last

      return false unless last_use.present?

      last_use.created_at > (DateTime.now - 1.hour)
    end

    def build_message_with_word(word)
      "#{word.main} - #{word.description}"
    end
  end
end
