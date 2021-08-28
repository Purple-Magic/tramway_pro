# frozen_string_literal: true

module BotTelegram::Leopold::ItWayPro
  CHAT_ID = '-1001141858122'

  include ::BotTelegram::Leopold::ItWayPro::WordsCheck

  def it_way_process(text)
    words = words_to_explain(text)
    if words.class.to_s == 'Word'
      send_word words
    else
      words&.each do |word|
        send_word word
      end
    end
  end

  def send_word(word)
    unless sended_recently? word
      message_to_chat bot, chat, "#{word.main} - #{word.description}"
      ::ItWay::WordUse.create! word_id: word.id, chat_id: chat.id
    end
    message_to_chat bot, chat, bot_record.options['you_can_add_words'] if chat.private?
  end

  def sended_recently?(word)
    uses = ::ItWay::WordUse.where(word_id: word.id, chat_id: chat.id)

    uses.last&.created_at&.>(DateTime.now - 1.hour)
  end
end
