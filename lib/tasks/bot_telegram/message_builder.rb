module BotTelegram
  class MessageBuilder
    attr_reader :text

    def initialize(attributes)
      @text = attributes[:text]
      @reply_markup = attributes[:reply_markup]
    end

    def reply_markup
      Telegram::Bot::Types::ReplyKeyboardMarkup.new(**@reply_markup)
    end
  end
end
