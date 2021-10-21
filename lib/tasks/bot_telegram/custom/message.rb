# frozen_string_literal: true

require 'telegram/bot'

class BotTelegram::Custom::Message
  def initialize(text: nil, file: nil, reply_markup: nil, inline_keyboard: nil)
    @text = text
    @file = file
    @reply_markup = reply_markup
    @inline_keyboard = inline_keyboard
  end

  def build_options(button)
    button_options = { text: button[0] }
    button_options.merge! callback_data: button[1][:data].to_json if button[1][:data].present?
    Telegram::Bot::Types::InlineKeyboardButton.new(**button_options)
  end

  def options
    arguments = {}
    arguments.merge!(text: @text) if @text.present?
    if @reply_markup.present?
      arguments.merge!(reply_markup: Telegram::Bot::Types::ReplyKeyboardMarkup.new(**@reply_markup))
    elsif @inline_keyboard.present?
      keyboard = @inline_keyboard.map do |button|
        if button[0].is_a? Array
          button.map do |b|
            build_options b
          end
        else
          build_options button
        end
      end
      arguments.merge!(reply_markup: Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: keyboard))
    end
    arguments
  end
end
