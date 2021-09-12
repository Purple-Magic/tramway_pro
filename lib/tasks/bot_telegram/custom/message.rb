require 'telegram/bot'

class BotTelegram::Custom::Message
  def initialize(text: nil, file: nil, reply_markup: nil, inline_keyboard: nil)
    @text = text
    @file = file
    @reply_markup = reply_markup
    @inline_keyboard = inline_keyboard
  end

  def options
    arguments = {}
    arguments.merge!(text: @text) if @text.present?
    if @reply_markup.present?
      arguments.merge!(reply_markup: Telegram::Bot::Types::ReplyKeyboardMarkup.new(**@reply_markup))
    elsif @inline_keyboard.present?
      keyboard = @inline_keyboard.map do |button|
        button_options = { text: button[0] }
        button_options.merge! switch_inline_query_current_chat: button[1][:answer] if button[1][:answer].present?
        Telegram::Bot::Types::InlineKeyboardButton.new **button_options
      end
      arguments.merge!(reply_markup: Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: keyboard))
    end
    arguments
  end
end
