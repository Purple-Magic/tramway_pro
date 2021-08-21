# frozen_string_literal: true

require_relative 'it_way_pro'
require_relative 'it_way_pro/words_check'
require_relative 'commands'

class BotTelegram::Leopold::Scenario
  include ::BotTelegram::MessagesManager
  include ::BotTelegram::Info
  include ::BotTelegram::Leopold::ItWayPro::WordsCheck

  IT_WAY_CHAT_ID = '-1001141858122'

  attr_reader :bot, :bot_record, :chat, :message_from_telegram

  def initialize(message_from_telegram, bot, bot_record, chat)
    @bot = bot
    @message_from_telegram = message_from_telegram
    @bot_record = bot_record
    @chat = chat
  end

  def run
    if chat_to_answer? chat
      text = message_from_telegram.text
      command = BotTelegram::Leopold::Command.new text
      if command.valid?
        command.run
      else
        words = words_to_explain(text)
        if words.class.to_s == 'Word'
          send_word words
        else
          words&.each do |word|
            send_word word
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

  def send_word(word)
    unless sended_recently? word
      message_to_chat bot, chat, "#{word.main} - #{word.description}"
      ::ItWay::WordUse.create! word_id: word.id, chat_id: chat.id
    end
    message_to_chat bot, chat, bot_record.options['you_can_add_words'] if chat.chat_type.private?
  end

  def sended_recently?(word)
    uses = ::ItWay::WordUse.where(word_id: word.id, chat_id: chat.id)

    uses.last&.created_at&.>(DateTime.now - 1.hour)
  end
end
